#!/bin/bash

defaultPipeline="pipeline"
customPipelineChoice=$defaultPipeline-$(date +'%Y-%m-%d')

# colors
red=$'\e[1;31m'
grn=$'\e[1;32m'
#yel=$'\e[1;33m'
#blu=$'\e[1;34m'
#mag=$'\e[1;35m'
#cyn=$'\e[1;36m'
end=$'\e[0m'

checkJQ() {
  # jq test
  type jq >/dev/null 2>&1
  exitCode=$?

  if [ "$exitCode" -ne 0 ]; then
    printf "  ${red}'jq' not found! (json parser)\n${end}"
    printf "    Ubuntu Installation: sudo apt install jq\n"
    printf "    Redhat Installation: sudo yum install jq\n"
    printf "    MacOS Installation: brew install jq\n"
    printf "${red}Missing 'jq' dependency, exiting.\n${end}"
    exit 1
  fi
}

checkPipelineName() {
  if [[ -z $1  ]]; then
    return
  fi

  if [[ ! $1 =~ ^.*\.[jJ][sS][oO][nN]$ ]]; then
    echo "${red}Pipeline name should be .json.${end}"
    echo "Exiting with code 1"
    exit 1
  fi

  if [[ ! -e $1 ]]; then
    echo "${red}File should exist.${end}"
    echo "Exiting with code 1"
    exit 1
  fi
}

getPoll() {
   if [[ "$1" =~ ^([yY][eE][sS]|[yY])$ ]]; then
   return 0
   fi
   return 1
}

# perform checks:
checkJQ

echo -n "Please, enter the pipeline’s definitions file path (default: $defaultPipeline.json): "
read -r pipelineName

checkPipelineName "$pipelineName"

if [ "$pipelineName" = "$customPipelineChoice" ]; then
  echo -n "Enter a CodePipeline name: "
  read -r pipelineName
fi

pipelineName=${pipelineName:-"$defaultPipeline.json"}

defaultBranchName="main"

echo -n "Enter a source branch to use (default: $defaultBranchName): "
read -r branchName
branchName=${branchName:-$defaultBranchName}

pipelineJson="pipeline.json"
customPipelineJson="$customPipelineChoice.json"

# remove metadata
jq 'del(.metadata)' "$pipelineJson" > "$customPipelineJson"

# increment version
jq '.pipeline.version =.pipeline.version + 1' "$customPipelineJson" >tmp.$$.json && mv tmp.$$.json "$customPipelineJson"

# upd source branch
jq --arg branchName "$branchName" '.pipeline.stages[0].actions[0].configuration.BranchName = $branchName' "$customPipelineJson" >tmp.$$.json && mv tmp.$$.json "$customPipelineJson"

#echo "Which BUILD_CONFIGURATION name are you going to use (default: “”): "
#read -r buildConfigVar

# upd config vars
#jq --arg buildConfigVar "$buildConfigVar" '.pipeline.stages = (.pipeline.stages[] | .actions[] | .configuration.EnvironmentVariables |= ({name: "BUILD_CONFIGURATION", value: $buildConfigVar, type:"PLAINTEXT"} | tojson))' "$customPipelineJson" >tmp.$$.json && mv tmp.$$.json "$customPipelineJson"


defaultProceedOpt="y"

echo -n "Proceed with ${pipelineName} pipeline update (y/n) (default: $defaultProceedOpt): "
read -r doProceed

doProceed=${doProceed:-$defaultProceedOpt}

if [ "$doProceed" = "n" ]; then
  echo "The ${pipelineName} pipeline update has been terminated."
  exit 0
fi

echo -n "Enter a GitHub owner/account: "
read -r owner

#set owner
jq --arg owner "$owner" '.pipeline.stages[0].actions[0].configuration.Owner = $owner' "$customPipelineJson" >tmp.$$.json && mv tmp.$$.json "$customPipelineJson"

echo -n "Enter a GitHub repo name: "
read -r repo

#set repo name
jq --arg repo "$repo" '.pipeline.stages[0].actions[0].configuration.Repo = $repo' "$customPipelineJson" >tmp.$$.json && mv tmp.$$.json "$customPipelineJson"

echo -n "Do you want the pipeline to poll for changes (yes/no) (default: no)?: "
read -r isPoll

getPoll "$isPoll"

isPoll=$?

jq --arg isPoll "$isPoll" '.pipeline.stages[0].actions[0].configuration.PollForSourceChanges = $isPoll == 0' "$customPipelineJson" >tmp.$$.json && mv tmp.$$.json "$customPipelineJson"

exit 0