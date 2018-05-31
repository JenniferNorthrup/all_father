#!/bin/bash
# AllFather Utilities
# By JenniferNorthrup

# Important variables
$OS_TYPE = 'None provided'

# Ask user's OS
echo Am I running on Mac \(m\), Windows \(w\) or Linux \(l\)?
read os_selection

if [ $os_selection == 'm' ]; then
	OS_TYPE='Mac'
elif [ $os_selection == 'w' ]; then
	OS_TYPE='Windows'
elif [ $os_selection == 'l' ]; then
	OS_TYPE='Linux'
else
	OS_TYPE='None Provided'
fi

echo I am running on a $os_type operating system


# Menu for basic setup and installations
echo =========================================================
echo ` `
echo Menu for basic setup and installations
echo ` `
echo =========================================================

function git_setup(){
  echo Setting up git user information...
  git config --global user.name = "Jennifer Northrup"
  git config --global user.email jenniferhnorthrup@gmail.com

  echo Setting up my favorite git aliases...
  git config --global alias.ripley 'log --graph --pretty=oneline --abbrev-commit -decorate --branches --remotes --tags HEAD'
  git config --global alias.last 'log -1 HEAD'
  git config --global alias.mylog 'log --all --decorate --oneline'
  echo .
}

function check_for_ssh_agent(){
  echo Checking for ssh agent...
  eval $(ssh-agent -s)
}

function setup_new_ssh_key(){
  echo Would you like me to generate a new ssh key?
  read SSH_CONTINUE
  if [ $SSH_CONTINUE == 'yes' ] || [ $SSH_CONTINUE == 'y' ]; then
    echo Generating an ssh key...
    ssh-keygen -t rsa -b 4096 -C "jenniferhnorthrup@gmail.com"
    echo Adding SSH private key to the ssh-agent...
    ssh-add ~/.ssh/id_rsa

  else
    echo I will not generate a new ssh key
    echo WARNING: No SSH key was generated!!!
  fi

}

retrieve_public_key(){
  if [ $OS_TYPE == 'Windows' ]; then
    clip < ~/.ssh/id_rsa.pub
  elif [ $OS_TYPE == 'Mac' ]; then
    pbcopy ~/.ssh/id_rsa.pub
  elif [ $OS_TYPE == 'Linux']; then
    xclip -selection c ~.ssh/id_rsa.pub
  else
    echo User did not specify OS. Attempting generic cp command...
    cp ~/.ssh/id_rsa.pub > /dev/clip
  fi
  echo \[\[ ATTENTION: your public key \(if it exists\) has been copied to your clipboard \]\]
  echo \[\[ - Click on GitHub profile photo \> Settings \> SSH and CPG keys \> Add/New SSH Key \]\]
}


SELECTION='None'
while [ $SELECTION != 'q' ]
do
  echo ` `
  echo ======== Basic setup and installation menu ========
  echo ` ` 
  echo Press 0 to run entire setup process in silent mode with default values
  echo Press 1 to set up Git/SSH for this computer
  echo Press 2 to copy your public SSH key to the clipboard

  read SELECTION

  case $SELECTION in
    1)
      echo GIT/SSH SETUP INITIALIZED
      git_setup
      check_for_ssh_agent

      echo Checking for existing SSH public keys...
      SSHKEYS=`ls -al ~/.ssh | grep .pub`
      if [ -z "$SSHKEYS" ]; then
        setup_new_ssh_key
      else 
        echo A public SSH key already exists on this computer:
	echo $SSHKEYS
      fi
      
      retrieve _public_key
      ;;
    2)
      retrieve_public_key
      ;;
    q)
      echo Quitting now...
      break
      ;;
    *)
      echo Please enter a valid number
      ;;
    esac
done

