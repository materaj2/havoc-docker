FROM ubuntu:20.04

### Set time zone
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC
RUN apt update && apt-get -y install tzdata
ENV QT_QPA_PLATFORM=offscreen

### Install prerequisite
RUN apt update && apt-get install -y pkg-config build-essential libmariadb-dev-compat
RUN apt update && apt install -y git apt-utils cmake libfontconfig1 libglu1-mesa-dev libgtest-dev libspdlog-dev libboost-all-dev libncurses5-dev libgdbm-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev mesa-common-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5websockets5 libqt5websockets5-dev qtdeclarative5-dev golang-go qtbase5-dev libqt5websockets5-dev libspdlog-dev python3-dev libboost-all-dev mingw-w64 nasm git wget vim
### For debian package
RUN apt update && apt install -y python3-dev libpython3-dev software-properties-common

WORKDIR /opt
### For python10
#RUN wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
#RUN tar xzvf Python-3.10.0.tgz && cd Python-3.10.0 && ./configure  --enable-optimizations && make -j 4 && make install
#RUN rm Python-3.10.0.tgz
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C
#COPY repo /etc/apt/sources.list.d/deadsnakes-ubuntu-ppa-lunar.list 
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F23C5A6CF475977595C89F51BA6932366A755776
RUN apt update && apt install -y python3.10 python3.10-dev curl

### For Havoc client
RUN git clone https://github.com/HavocFramework/Havoc.git
# Compile
RUN cd Havoc/Client && make
RUN cd /opt/Havoc/Teamserver/ && ./Install.sh

### Install Go
RUN rm -rf /usr/bin/go
RUN curl -LO https://go.dev/dl/go1.19.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.19.2.linux-amd64.tar.gz
RUN rm go1.19.2.linux-amd64.tar.gz
RUN echo "export GOPATH=＄HOME/work" >> ~/.profile 
RUN echo "export PATH=＄PATH:/usr/local/go/bin:＄GOPATH/bin" >> ~/.profile
RUN ln -s /usr/local/go/bin/go /usr/bin/go

### Install Havoc Teamserver
RUN apt update \
	&& apt -y install \
	alien \
	debhelper \
	devscripts \
	nasm \
	mingw-w64 \
	dh-golang \
	dh-make \
	fakeroot \
	pkg-config \
	python3-all-dev \
	python3-pip \
	rpm \
	sudo \
	upx-ucl \
	net-tools \
	&& pip install --upgrade jsonschema
RUN cd Havoc/Teamserver && go mod download golang.org/x/sys && go mod download github.com/ugorji/go
RUN cd Havoc/Teamserver && make

COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
