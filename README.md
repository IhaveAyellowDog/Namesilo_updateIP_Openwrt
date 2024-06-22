Step1:填写自己申请的域名中对应的值：
  key=""
  tel_id=""
  domain_name=""
  rrid=""
  #rrid will get the value later
  rrhost="www"
  rrttl="3601"  
Step2:将脚本放到/etc/config/ 目录下，这样升级或者备份Openwrt时都不会丢掉这个脚本

Step3:在putty或者其他终端工具中进行测试；

Step4：设置定期执行脚本，建议20分钟一次
  */20 * * * * sh /etc/config/update.sh


当检查到本机IP和DNS解析IP不一致将会更新DNS的解析IP；检查到一致时将会忽略。


