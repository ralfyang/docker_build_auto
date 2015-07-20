#!/bin/bash
### docker image build automation with verification
### Made by ralf.yang@gsshop.com, goody80762@gmail.com


## YOU CAN CHANGE THE COMMAND for WHAT YOU WANT AS BELOW CheckCommand.
CheckCommand="rpm -qa |grep sshd"

Output="/tmp/build_auto.list"
BAR="====================================="

## Please modify under variable for the private repository if you have.
sudo_pkg_check=`rpm -qa  2> /dev/null |grep "^sudo"`
	if [[ $sudo_pkg_check = "" ]]; then
		Comm="docker"
	else
		Comm="sudo docker"
	fi


ImagesList=(`ls -d */ | sed -e 's#/##g'`)
	if [[ $ImagesList = "" ]];then
		echo ""
		echo " === Please make sure the target Dockerfile or directory ! ==="
		echo ""
		exit 0;
	fi

clear
	Count=0
	echo "" > $Output
	echo "$BAR" >> $Output
	while [ $Count -lt ${#ImagesList[@]} ]; do
		echo "$((Count+1)) | ${ImagesList[$Count]}" >> $Output
	let Count=$Count+1
	done
	echo "$BAR" >> $Output
## Menu
cat $Output
echo "Please insert a number for build:"
read build_num

## Select a number for work
DockerName=`grep "^$build_num" $Output | awk '{print $3}'`
DockerNameOut="$DockerName.out"
ErrorOut="buildauto.err"
EnablePortArry=(`cat ./$DockerName/Dockerfile |grep EXPOSE | sed -e 's/EXPOSE //g'`)

## Check build success
$Comm build -t $DockerName ./$DockerName |tee $DockerNameOut
	if [[ `(grep  "Successfully built" $DockerNameOut)` = "" ]];then
		echo "$BAR"
		echo "Build failed!!!"
		echo "$BAR"
		exit 0;
	fi

## Running docker for check
$Comm run -d --name $DockerName $DockerName tailf /etc/resolv.conf
	if [[ `($Comm exec $DockerName $CheckCommand)` = "" ]];then
		echo "$BAR"
		echo " Pacakge dose not install in Docker image yet!!"
		echo "$BAR"
		exit 0;
	fi


	if [[ ${EnablePortArry[@]} != "" ]];then
		if [[ `($Comm ps |grep ${EnablePortArry[0]})` = "" ]];then
			echo ""
			echo "$BAR"
			echo "EXPOSE Port has not attented"
			echo "$BAR"
			exit 0;
		else
			echo " === Port EXPOSE check==="
			$Comm ps |grep ${EnablePortArry[0]}
		fi
	fi


## Everything is fine
echo " Stopping the Temporary container....."
$Comm stop $DockerName
$Comm rm $DockerName

echo ""
ImgChk=`$Comm images |grep "verified/$DockerName"`
	if [[ $ImgChk != "" ]];then
		echo "$BAR"
		echo "Image name already existed!"
		echo "$BAR"
	fi
echo " Running new container for tagging new...."

$Comm tag $DockerName verified/$DockerName

echo "$BAR"
echo " Good job!  everything is okay!"
$Comm images |grep "verified/$DockerName"
echo "$BAR"
rm -f $DockerNameOut $ErrorOut

