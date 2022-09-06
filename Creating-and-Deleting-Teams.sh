#!/bin/bash

. /home/rohan/Downloads/variables.properties

x=0

###### Azure Login ######

echo 'Loging to Azure devops'

az devops login --organization $org_url


######################

if [[ $1 == "-d" ]];
then

#####
## Listing all teams
#####

echo 'Listing all teams'
echo
az devops team list --detect --project $project_name --output table
echo
echo

#####
## Deleting Teams
#####

	echo 'Deleting Teams'
        echo
        team=`az devops team list --detect --project $project_name`
        arr=($team)
        for i in "${arr[@]}"
        do
                echo
                echo 'Enter the team name you want to delete'
                echo
                read ID
                TEAM=`az devops team show --team $ID --project $project_name`
                if [ "$TEAM" = "" ]; then
                        echo 'Team does not exist'
                else
                        az devops team delete --id $ID  --detect --project "$project_name"
                        echo "Team Deleted successfully"
                fi
        done
        echo
        echo
else

#####
## Creating teams
#####

	echo 'Creating Teams'
        echo
        arr=($student_name)
        for i in "${arr[@]}"
        do
                ((x++))
                az devops team create --name $i'0'$x'-team'  --detect --project "$project_name"
                if [ $? -eq 0 ]; then
                        echo "Team Created Successfully "
                else
                        echo "Team is Already Created"
                fi
        done
        echo
        echo

#####
## Listing all teams
#####

echo 'Listing all teams'
echo
az devops team list --detect --project $project_name --output table
echo
echo
	
fi
