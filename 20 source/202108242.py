
import matplotlib.pyplot as plt
#matplotlib inline
import numpy as np
import pandas as pd
import os
os.environ["PATH"] += os.pathsep + 'C:/Program Files (x86)/Graphviz/bin'
 
from sklearn.datasets import load_iris
from sklearn import tree
 
iris = load_iris()
 
# 训练模型
clf =  tree.DecisionTreeClassifier()
clf = clf.fit(iris.data, iris.target)
with open("iris.dot", 'w') as f:
    f = tree.export_graphviz(clf, out_file=f)
 
 
from IPython.display import Image  
import pydotplus
 
dot_data = tree.export_graphviz(clf, out_file=None, 
                         feature_names=iris.feature_names,  
                         class_names=iris.target_names,  
                         filled=True, rounded=True,  
                         special_characters=True)
 
 
graph = pydotplus.graph_from_dot_data(dot_data)
 
# 模型可视化
Image(graph.create_png())
