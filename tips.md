## 七牛云bucket之间迁移数据

以下方法使用同一区域的bucket之间数据迁移

```bash
qshell listbucket jverson cp.txt //将名为jverson的源bucket中文件信息输出到 cp.txt 中
cat cp.txt | awk '{print $1}' >cpp.txt //通过awk字符处理命令将cp.txt中的内容只保留第一列存为cpp.txt，即得到文件列表
qshell batchcopy jverson new cpp.txt //将jverson中的文件全部复制到new的新bucket中
```
