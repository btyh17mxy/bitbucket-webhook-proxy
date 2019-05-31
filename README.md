# Bitbucket webhook proxy

Bitbucket 最近由于GDPR的影响, [修改了webhook中的部分字段名称](https://developer.atlassian.com/cloud/bitbucket/bitbucket-api-changes-gdpr/?_ga=2.232204255.1982639683.1559275832-1038104163.1557325445&_gac=1.86563946.1558339475.Cj0KCQjwoInnBRDDARIsANBVyAQe62UKM-kz7Tw0nxeWqRWk9xIAxwyXIe1k3WZb-7OVanhHCiolu3waAlfcEALw_wcB), 导致jenkins的[bitbucket-plugin](https://github.com/jenkinsci/bitbucket-plugin) 报出下图的异常.

Bitbucket recently [changed it's REST APIs](https://developer.atlassian.com/cloud/bitbucket/bitbucket-api-changes-gdpr/?_ga=2.232204255.1982639683.1559275832-1038104163.1557325445&_gac=1.86563946.1558339475.Cj0KCQjwoInnBRDDARIsANBVyAQe62UKM-kz7Tw0nxeWqRWk9xIAxwyXIe1k3WZb-7OVanhHCiolu3waAlfcEALw_wcB) due to the GDPR regulations, and cause jenkins's [bitbucket-plugin](https://github.com/jenkinsci/bitbucket-plugin) throw an exception as the below.

![](https://lens.dailyinnovation.biz/AlfredUpload/9dc159b262015a0ad7292a6c14cac9dd.png)

似乎[bitbucket-plugin](https://github.com/jenkinsci/bitbucket-plugin)还没做出相应的更新, 因此写了这个东西来把webhook的参数改成原来的样子.

It seems [bitbucket-plugin](https://github.com/jenkinsci/bitbucket-plugin) has not adapted this change yet, so I write this to modify webhook payload into origin style.
