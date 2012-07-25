# 安装配置 CoreSeek

## 安装基础系统依赖库

### 安装 m4
版本要求 m4 >= 1.4.13
下载地址 ftp://ftp.gnu.org/gnu/m4/m4-1.4.13.tar.gz
安装方法
```
  ./configure && make && make install
```

### autoconf
版本要求 autoconf >= 2.65
下载地址 ftp://ftp.gnu.org/gnu/autoconf/autoconf-2.65.tar.gz
```
  ./configure && make && make install
```


### automake
版本要求 automake >= 1.11
下载地址 http://ftp.gnu.org/gnu/automake/automake-1.11.tar.gz
```
  ./configure && make && make install
```

### libtool
版本要求 libtool >= 2.2.6b
下载地址 http://ftp.gnu.org/gnu/libtool/libtool-2.2.6b.tar.gz
```
  ./configure && make && make install
```

### mysql-devel
安装方法 用 yast 安装


## 安装 CoreSeek
下载地址 wget http://www.coreseek.cn/uploads/csft/3.2/coreseek-3.2.14.tar.gz
下载解压缩，安装包里包含 mmseg coreseek testpack

### 安装 mmseg

```
  cd mmseg-3.2.14
  ./bootstrap    #输出的warning信息可以忽略，如果出现error则需要解决
  ./configure --prefix=/usr/local/mmseg3
  make && make install
```

### 安装 coreseek

```
  cd csft-3.2.14
  sh buildconf.sh    #输出的warning信息可以忽略，如果出现error则需要解决
  ./configure --prefix=/usr/local/coreseek  --without-unixodbc --with-mmseg --with-mmseg-includes=/usr/local/mmseg3/include/mmseg/ --with-mmseg-libs=/usr/local/mmseg3/lib/ --with-mysql    ##如果提示mysql问题，可以查看MySQL数据源安装说明
  make && make install
```

### 测试mmseg分词，coreseek搜索（需要预先设置好字符集为zh_CN.UTF-8，确保正确显示中文）

```
  cd testpack
  cat var/test/test.xml    #此时应该正确显示中文
  /usr/local/mmseg3/bin/mmseg -d /usr/local/mmseg3/etc var/test/test.xml
  /usr/local/coreseek/bin/indexer -c etc/csft.conf --all
  /usr/local/coreseek/bin/search -c etc/csft.conf 网络搜索
```

### 设置 PATH

```
  vi /etc/profile
  # 增加 coreseek,mmseg3 到 PATH
  export PATH=/usr/local/coreseek/bin:$PATH
  export PATH=/usr/local/mmseg3/bin:$PATH
```

### 启动 Thinking Sphinx

```
  cd pin-2012-edu/pin-edu-sns
  rake thinking_sphinx:start
```
点击[这里](http://freelancing-god.github.com/ts/en/rake_tasks.html) 查看详细的 Thinking Sphinx 使用说明


