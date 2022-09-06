#!/bin/sh

. "/home/rohan/Downloads/variables.properties"

az config set extension.use_dynamic_install=yes_without_prompt

az devops configure --defaults organization="$org_url" project="$project_name"

##### For Creating Repositories ###########

if [[ $repo_name ]];
then
	mkdir file
	cd file
	git init
	echo "This is README file" > README.md
	git add README.md
	git commit -m "Added"
	for i in $student_name;do
		let INDEX=$INDEX+1
		for j in $repo_name;do
			az repos create --name "$i"_"$INDEX"-"$j"
			git push "$github_url""$i"_"$INDEX"-"$j" master
		done
	done
else
	echo 
	echo "If you wish to create a repository then mention. Then you need to define it in the variables.txt"
fi 
echo
echo "Your current Repositories are given below:"

az repos list --out table

############ For Deleting Repositories ############

name=$1
if [[ "$name" == "-d" ]] ;
then
	echo
	echo "Please Do not Press any key and wait untill the whole process is done:"
	echo
	cd ..
	az repos list --out table > ./file/output.txt
	awk '{
	if($2 !="azure-pipeline-yaml-templates" && $2 !="Continuous Integration and Delivery" && $1 !="ID" && $1 !="------------------------------------")
		{
			print $1;
		}
}' ./file/output.txt > ./file/repos_to_delete.txt
while read firstcol secondcol;do
	az repos delete --id "$firstcol" --yes
done < "./file/repos_to_delete.txt"
else
	echo
	echo "Warning: If you want to delete all Repositories then you have to pass '-d' parameter while running the script." 
fi
