#生成的新镜像以centos镜像为基础
FROM centos:7
MAINTAINER by herman.tian(herman.tian@outlook.com)
#升级系统
RUN yum -y update
RUN yum -y install epel-release 
#安装openssh-server、client
RUN yum -y install openssh-server openssh-clients.x86_64 vim less wget sudo make gcc
RUN yum -y install the_silver_searcher cmake git zsh autojump autojump-fish autojump-zsh ctags
#修改/etc/ssh/sshd_config
#RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

#将密钥文件复制到/etc/ssh/目录中。这里要用root的权限生成key
RUN mkdir -p /root/.ssh
#生成秘钥、公钥
RUN ssh-keygen -t rsa -b 2048 -P '' -f /root/.ssh/id_rsa
RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
RUN cp /root/.ssh/id_rsa /etc/ssh/ssh_host_rsa_key
RUN cp /root/.ssh/id_rsa.pub /etc/ssh/ssh_host_rsa_key.pub

#定义时区参数
ENV TZ=Asia/Shanghai
#设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

#将ssh服务启动脚本复制到/usr/local/sbin目录中，并改变权限为755
ADD run.sh /usr/local/sbin/run.sh
RUN chmod 755 /usr/local/sbin/run.sh

#变更root密码为root
RUN echo "root:root"| chpasswd
#开放窗口的22端口
EXPOSE 22
#运行脚本，启动sshd服务
CMD ["/usr/local/sbin/run.sh"]
