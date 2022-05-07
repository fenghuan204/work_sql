#!D:/ProgramData/Anaconda3/python.exe
# -*- coding: UTF-8 -*-

#-------------------------------------------------------------
#20210824之前的test结果
#---------------------------------------------------------------
print("hello world")
counter = 100  # 赋值整型变量
miles = 1000.0  # 浮点型
name = "John"  # 字符串
print(miles)

a = b = c = 1
print(c)
a, b, c = 1, 2100.0, "john"
print(b)

#-------------------------------------------------------------
#20210824test结果
#---------------------------------------------------------------

import pandas as pd  # pandas 是python语言的一个扩展程序库，series/dateframe
import numpy as np   # numpy 是python语言的一个扩展程序库，支持维度数组和矩阵运算
import scipy
import time,datetime
from category_encoders import CountEncoder
import sys
## print(sys.path)


path  = 'E:\py_job\客舱精准营销\参考代码'
print(path)
path_train = path + '\数据源与SQL\\'
print(path_train)
today_str = datetime.date.today().strftime("%Y-%m-%d")
today_time = pd.to_datetime(today_str)
print(today_str)

def get_data(sql,col,day):  #python函数功能，函数名（函数参数）
    sql = sql.replace('%d',str(day)) #跑sql日期选取 填180代表选取日期从今天往前180天
    cursor = conn.cursor()
    cursor.execute(sql)
    data = pd.DataFrame(cursor.fetchall(),columns=col)
    return data

#-------------------------------------------------------------
# replace：str.replace(old, new[, max])
# old -- 将被替换的子字符串。
# new -- 新字符串，用于替换old子字符串。
# max -- 可选字符串, 替换不超过 max 次
#---------------------------------------------------------------

str = "this is string example....wow!!! this is really string";
print str.replace("is", "was");
print str.replace("is", "was", 3);

#-------------------------------------------------------------
# import time 引入time模块
#
#---------------------------------------------------------------

