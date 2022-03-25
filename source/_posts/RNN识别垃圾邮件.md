---
title: RNN识别垃圾邮件
copyright: false
tags:
  - machine learning
categories: 机器学习
abbrlink: 65e9fc1f
date: 2020-01-03 20:24:22
---



## 1. 获取数据集及处理思路

[SMS垃圾邮箱数据集](https://www.kaggle.com/uciml/sms-spam-collection-dataset)

这个数据有两列，一列为标记，值为`ham` `spam`，第二列为邮件文本数据。

- 判断邮件是否为垃圾邮件——分类问题
- 输出y可以设为0或1，1代表spam垃圾邮箱，0代表ham非垃圾邮箱
- 处理的输入数据x是文本数据、序列数据，可以建立一个多对一的RNN模型



## 2. 训练神经网络

### 1. 加载包

```python
import os
import re
import io
import requests
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from zipfile import ZipFile
from tensorflow.python.framework import ops

ops.reset_default_graph() 
```

其中`ops.reset_default_graph() `是对default graph重新初始化，清空所有张量

#### 1.1 为graph建立会话

```python
sess = tf.Session()
```

#### 1.2 设定RNN模型的参数

```python
epochs = 30 # 执行30代
batch_size = 250 
max_sequence_length = 25 # 考虑的每个文本的最大长度为25个单词，这样会将较长的文本剪切为25个，不足的用零填充
rnn_size = 10
embedding_size = 50
min_word_frequency = 10
learning_rate = 0.0005
dropout_keep_prob = tf.placeholder(tf.float32)
# RNN 有 10 个单元， 每个单词都将被嵌入到一个长度为 50 的可训练向量中， 只考虑我们的 vocabulary 中出现 10 次以上的单词， 学习率设置为 0.0005 dropout 先由一个占位符定义，我们可以在训练时将其设置为 0.5， 或在评估时设置为 1.0
```

### 2. 导入数据

下载数据存为text_data.txt

```python
# 设定路径
data_dir = 'temp'
data_file = 'text_data.txt'
if not os.path.exists(data_dir):
    os.makedirs(data_dir)
    
# 直接下载数据集
if not os.path.isfile(os.path.join(data_dir, data_file)):
    zip_url = 'http://archive.ics.uci.edu/ml/machine-learning-databases/00228/smsspamcollection.zip'
    r = requests.get(zip_url)
    z = ZipFile(io.BytesIO(r.content))
    file = z.read('SMSSpamCollection')

    # 格式化数据
    text_data = file.decode()
    text_data = text_data.encode('ascii', errors='ignore')
    text_data = text_data.decode().split('\n')

    # 将数据存储到 text 文件
    with open(os.path.join(data_dir, data_file), 'w') as file_conn:
        for text in text_data:
            file_conn.write("{}\n".format(text))
else:
    # 从 text 文件打开数据
    text_data = []
    with open(os.path.join(data_dir, data_file), 'r') as file_conn:
        for row in file_conn:
            text_data.append(row)
    text_data = text_data[:-1]
```

#### 2.1 数据预处理

```python
# 将数据中的标签和邮件文本分开
# 得到 text_data_target 和 text_data_train
text_data = [x.split('\t') for x in text_data if len(x) >= 1]
[text_data_target, text_data_train] = [list(x) for x in zip(*text_data)]
```

- 为了减少vocabulary，先清理文本，移除特殊字符，删除多余空格，将文本换成小写

```python
# 这是一个文本清理函数
def clean_text(text_string):
    text_string = re.sub(r'([^\s\w]|_|[0-9])+', '', text_string)
    text_string = " ".join(text_string.split())
    text_string = text_string.lower()
    return text_string

# 调用clean_text 清理文本
text_data_train = [clean_text(x) for x in text_data_train]
```

- 接下来将文本转为词的ID序列

```python
# 用 TensorFlow 中一个内置的 VocabularyProcessor 函数来处理文本
# max_document_length: 是文本的最大长度。如果文本的长度大于这个值，就会被剪切，小于这个值的地方用 0 填充。 
# min_frequency: 是词频的最小值。当单词的出现次数小于这个词频，就不会被收录到词表中。
vocab_processor = tf.contrib.learn.preprocessing.VocabularyProcessor(max_sequence_length, min_frequency=min_word_frequency)
text_processed = np.array(list(vocab_processor.fit_transform(text_data_train)))
```

该方法的例子

```python
# 给出以下数据
max_document_length = 4
x_text =[
    'i love you',
    'me too'
]

# 返回结果是
[[1 2 3 0]
 [4 5 0 0]]
```

#### 2.2 分为训练集和测试集

预处理后，将数据进行shuffle，再分为训练集和测试集

- shuffle打乱数据行序，使数据随机化。这样参数就不容易陷入局部最优，模型更容易达到收敛，`np.random.permutation()`来对行索引进行一次全排列

  ```python
  text_processed = np.array(text_processed)
  text_data_target = np.array([1 if x == 'ham' else 0 for x in text_data_target])
  shuffled_ix = np.random.permutation(np.arange(len(text_data_target)))
  x_shuffled = text_processed[shuffled_ix]
  y_shuffled = text_data_target[shuffled_ix]
  ```

- shuffle 数据后，将数据集分为 80% 训练集和 20% 测试集 如果想做交叉验证 cross-validation ，可以将 测试集 进一步分为测试集和验证集来调参。

  ```python
  ix_cutoff = int(len(y_shuffled)*0.80)
  x_train, x_test = x_shuffled[:ix_cutoff], x_shuffled[ix_cutoff:]
  y_train, y_test = y_shuffled[:ix_cutoff], y_shuffled[ix_cutoff:]
  vocab_size = len(vocab_processor.vocabulary_)
  print("Vocabulary Size: {:d}".format(vocab_size))
  print("80-20 Train Test split: {:d} -- {:d}".format(len(y_train), len(y_test)))
  ```

  将会输出

  ```python
  Vocabulary size: 933
  80-20 Train Test split: 4459 -- 1115
  ```

#### 2.3 将输入数据做词嵌入Embedding



