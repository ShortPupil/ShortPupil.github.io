---
title: java集合源码——ArrayList
tags:
  - java
  - source code
copyright: true
categories: java
abbrlink: 771d1ebd
date: 2020-03-12 13:10:24
---

<!-- toc -->



ArrayList 动态数组，可动态扩展，是**数组**实现的list。



## 源码分析



### 继承实现

---

```java
public class ArrayList<E> extends AbstractList<E>
        implements List<E>, RandomAccess, Cloneable, java.io.Serializable
```

- ArrayList实现了List，提供了list的的**添加**、**删除**、**遍历**等操作。
- ArrayList实现了RandomAccess，提供了**随机访问**的能力。
- ArrayList实现了Cloneable，可以被**克隆**。
- ArrayList实现了Serializable，可以被**序列化**。



### 属性

---

```java
/**
 * 默认容量10,通过new ArrayList()创建时的默认容量
 */
private static final int DEFAULT_CAPACITY = 10;

/**
 * 空数组，如果传入的容量为0时使用，即new ArrayList(0)
 */
private static final Object[] EMPTY_ELEMENTDATA = {};

/**
 * 空数组，传传入容量时使用，添加第一个元素的时候会重新初始为默认容量大小
 */
private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = {};

/**
 * 真正存储元素的数组，使用transient修饰是为了不序列化这个字段
 */
transient Object[] elementData;
// non-private to simplify nested class access

/**
 * 真正存储元素的个数，而不是elementData的长度
 */
private int size;
```



### 构造方法

---

构造方法一

```java
/*传入初始容量，如果大于0就初始化elementData为对应大小，如果等于0就使用EMPTY_ELEMENTDATA空数组，如果小于0则异常*/
	public ArrayList(int initialCapacity) {
        if (initialCapacity > 0) {
            //新建一个数组存储元素
            this.elementData = new Object[initialCapacity];
        } else if (initialCapacity == 0) {
            //使用空数组
            this.elementData = EMPTY_ELEMENTDATA;
        } else {
            //抛出异常
            throw new IllegalArgumentException("Illegal Capacity: "+
                                               initialCapacity);
        }
    }
```

构造方法二

```java
/*默认构造方法，初始化为DEFAULTCAPACITY_EMPTY_ELEMENTDATA的空数组，会在添加第一个元素的时候扩容为默认大小，即10*/	
	public ArrayList() {
        this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
    }
```

构造方法三

```java
/*传入集合的构造方法，用拷贝，把传入集合的元素拷贝进elementData数组，如果元素为0，则初始化EMPTY_ELEMENTDATA空数组*/
 	public ArrayList(Collection<? extends E> c) {
        elementData = c.toArray();
        if ((size = elementData.length) != 0) {
            // c.toArray might (incorrectly) not return Object[] (see 6260652)
            if (elementData.getClass() != Object[].class)
                elementData = Arrays.copyOf(elementData, size, Object[].class);
        } else {
            // replace with empty array.
            this.elementData = EMPTY_ELEMENTDATA;
        }
    }
```

注意，`c.toArray();`返回的可能不是Object[]类型



### add系列方法

---

#### add(E e)方法

新增单个元素，时间复杂度O(1)

1. 检查是否需要扩容；
2. 如果elementData等于DEFAULTCAPACITY_EMPTY_ELEMENTDATA则初始化容量大小为DEFAULT_CAPACITY；
3. 新容量是老容量的1.5倍（oldCapacity + (oldCapacity >> 1)），如果加了这么多容量发现比需要的容量还小，则以需要的容量为准；
4. 创建新容量的数组并把老数组拷贝到新数组；

```java
	private static int calculateCapacity(Object[] elementData, int minCapacity) {
        //如果是空数组，直接初始化默认大小为10
        if (elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {
            return Math.max(DEFAULT_CAPACITY, minCapacity);
        }
        return minCapacity;
    }

    private void ensureCapacityInternal(int minCapacity) {
        //再用ensureExplicitCapacity方法
        ensureExplicitCapacity(calculateCapacity(elementData, minCapacity));
    }

    private void ensureExplicitCapacity(int minCapacity) {
        modCount++;
        // overflow-conscious code。扩容代码
        if (minCapacity - elementData.length > 0)
            grow(minCapacity);
    }
	    
	private static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;

	/**arrayList的扩容方法*/
    private void grow(int minCapacity) {
        // overflow-conscious code
        int oldCapacity = elementData.length;
        //新容量为旧容量的1.5倍
        int newCapacity = oldCapacity + (oldCapacity >> 1);
        //新容量比需要的容量还小，则以需要的容量为准
        if (newCapacity - minCapacity < 0)
            newCapacity = minCapacity;
        //新容量比最大容量还大，则使用最大容量
        if (newCapacity - MAX_ARRAY_SIZE > 0)
            newCapacity = hugeCapacity(minCapacity);
        // minCapacity is usually close to size, so this is a win:
        //以新容量拷贝出来一个新数组
        elementData = Arrays.copyOf(elementData, newCapacity);
    }

    private static int hugeCapacity(int minCapacity) {
        if (minCapacity < 0) // overflow
            throw new OutOfMemoryError();
        return (minCapacity > MAX_ARRAY_SIZE) ?
            Integer.MAX_VALUE :
            MAX_ARRAY_SIZE;
    }

	public boolean add(E e) {
        //检查是否需要扩容
        ensureCapacityInternal(size + 1);  // Increments modCount!!
        //把元素插入到最后一位
        elementData[size++] = e;
        return true;
    }
```



#### add(int index, E element) 方法

添加元素到指定位置，时间复杂度O(n)

步骤

1. 检查index是否越界
2. 检查是否需要扩容
3. 把传入索引位置后的元素往后移
4. 在插入索引位置放置插入的元素
5. 大小+1

```java
	private void rangeCheckForAdd(int index) {
        if (index > size || index < 0)
            throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
    }
	public void add(int index, E element) {
        rangeCheckForAdd(index);

        ensureCapacityInternal(size + 1);  // Increments modCount!!
        System.arraycopy(elementData, index, elementData, index + 1,
                         size - index);
        elementData[index] = element;
        size++;
    }
```



#### addAll(Collection<? extends E> c)

两个集合的并集

步骤

1. 拷贝c中的元素到数组a中
2. 检查是否需要扩容
3. 把数据a中的元素拷贝到elementData的尾部

```java
	public boolean addAll(int index, Collection<? extends E> c) {
            rangeCheckForAdd(index);
            int cSize = c.size();
            if (cSize==0)
                return false;

            checkForComodification();
            parent.addAll(parentOffset + index, c);
            this.modCount = parent.modCount;
            this.size += cSize;
            return true;
        }
```



### get remove等方法

---

#### get(int index)方法

时间复杂度O(1)

1. 检查索引是否越界，越上界抛出IndexOutOfBoundsException异常，越下界抛出的是ArrayIndexOutOfBoundsException异常。
2. 返回索引位置处的元素

```java
	public E get(int index) {
        rangeCheck(index);

        return elementData(index);
    }
	private void rangeCheck(int index) {
        if (index >= size)
            throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
    }
```



#### remove(int index)方法

**删除指定索引位置的元素**，时间复杂度O(n)

1. 检查索引是否越界
2. 获取指定索引位置的元素
3. 如果删除的不是最后一位，则其他元素前移一位
4. 将最后一位设为null，**方便gc回收**
5. 返回删除的元素

```java
	public E remove(int index) {
        Objects.checkIndex(index, size);
        final Object[] es = elementData;

        @SuppressWarnings("unchecked") E oldValue = (E) es[index];
        fastRemove(es, index);

        return oldValue;
    }

	private void fastRemove(Object[] es, int i) {
        modCount++;
        final int newSize;
        if ((newSize = size - 1) > i)
            System.arraycopy(es, i + 1, es, i, newSize - i);
        es[size = newSize] = null;
    }
```



#### retainAll(Collection c)方法

两个集合的交集

1. 遍历elementData数组
2. 如果元素在c中，则把这个元素添加到elementData数组的w位置并将w位置往后移一位
3. 遍历完之后，w之前的元素都是两者共有的，w之后（包含）的元素不是两者共有的
4. 将w之后（包含）的元素置为null，方便GC回收

```java
    public boolean retainAll(Collection<?> c) {
        Objects.requireNonNull(c);
        return batchRemove(c, true);
    }

    private boolean batchRemove(Collection<?> c, boolean complement) {
        final Object[] elementData = this.elementData;
        int r = 0, w = 0;
        boolean modified = false;
        try {
            for (; r < size; r++)
                if (c.contains(elementData[r]) == complement)
                    elementData[w++] = elementData[r];
        } finally {
            // Preserve behavioral compatibility with AbstractCollection,
            // even if c.contains() throws.
            if (r != size) {
                System.arraycopy(elementData, r,
                                 elementData, w,
                                 size - r);
                w += size - r;
            }
            if (w != size) {
                // clear to let GC do its work
                for (int i = w; i < size; i++)
                    elementData[i] = null;
                modCount += size - w;
                size = w;
                modified = true;
            }
        }
        return modified;
    }

```



#### removeAll(Collection<?> c)

```java
public boolean removeAll(Collection<?> c) {
    // 集合c不能为空
    Objects.requireNonNull(c);
    // 同样调用批量删除方法，这时complement传入false，表示删除包含在c中的元素
    return batchRemove(c, false);
}
```

因此

- ArrayList支持求并集，调用addAll(Collection<? extends E> c)方法即可；
- ArrayList支持求交集，调用retainAll(Collection<? extends E> c)方法即可；
- ArrayList支持求单向差集，调用removeAll(Collection<? extends E> c)方法即可；



### 注意

- elementData设置成了transient，则ArrayList怎么序列化元素？

- 查看writeObject()方法可知，先调用s.defaultWriteObject()方法，再把size写入到流中，再把元素一个一个的写入到流中。

  一般地，只要实现了Serializable接口即可自动序列化，writeObject()和readObject()是为了自己控制序列化的方式，这两个方法必须声明为private，在java.io.ObjectStreamClass#getPrivateMethod()方法中通过反射获取到writeObject()这个方法。

  在ArrayList的writeObject()方法中先调用了s.defaultWriteObject()方法，这个方法是写入非static非transient的属性，在ArrayList中也就是size属性。同样地，在readObject()方法中先调用了s.defaultReadObject()方法解析出了size属性。

  elementData定义为transient的优势，自己根据size序列化真实的元素，而不是根据数组的长度序列化元素，减少了空间占用。

```java
private void writeObject(java.io.ObjectOutputStream s)
        throws java.io.IOException{
    // 防止序列化期间有修改
    int expectedModCount = modCount;
    // 写出非transient非static属性（会写出size属性）
    s.defaultWriteObject();

    // 写出元素个数
    s.writeInt(size);

    // 依次写出元素
    for (int i=0; i<size; i++) {
        s.writeObject(elementData[i]);
    }

    // 如果有修改，抛出异常
    if (modCount != expectedModCount) {
        throw new ConcurrentModificationException();
    }
}

private void readObject(java.io.ObjectInputStream s)
        throws java.io.IOException, ClassNotFoundException {
    // 声明为空数组
    elementData = EMPTY_ELEMENTDATA;

    // 读入非transient非static属性（会读取size属性）
    s.defaultReadObject();

    // 读入元素个数，没什么用，只是因为写出的时候写了size属性，读的时候也要按顺序来读
    s.readInt();

    if (size > 0) {
        // 计算容量
        int capacity = calculateCapacity(elementData, size);
        SharedSecrets.getJavaOISAccess().checkArray(s, Object[].class, capacity);
        // 检查是否需要扩容
        ensureCapacityInternal(size);
        
        Object[] a = elementData;
        // 依次读取元素到数组中
        for (int i=0; i<size; i++) {
            a[i] = s.readObject();
        }
    }
}
```



















