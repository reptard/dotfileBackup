#!/usr/bin/env bash

cd $HOME;
mkdir "$HOME"/dotOld;


# check if git is installed
if [ -x $(command -v git) ]; then
	dotconfs="$HOME/dotfileBackup/dotConfigs"
	# clone, and check if any errs. If so, exit. Leave files as they be..
	git clone "https://github.com/reptard/dotfileBackup.git" --quiet;
	err=$?
	if ! [[ $err ]]; then 
		echo "Error in cloning. Exiting.";
		exit 1;
	fi

	# assigned to variable to reuse later on.
	# may need to make recursive ls. As configs grow.
	backups=$(ls -A $HOME/dotfileBackup/dotConfigs);
	# check for files that will be deleted,
	# back them up.
	for file in $backups;
	do
		# check file type
		if [ -f $dotconfs/$file ]; then 
			# check if file already exists.
			# if so, backup to dotOld.
			[[ -f $HOME/$file ]] && cp "$HOME"/$file "$HOME"/dotOld;
			# put in home, weather it was there or not.
			cp $dotconfs/$file $HOME;
		fi
		# same but for dirs.
		if [ -d $dotconfs/$file ]; then
			[[ -d $HOME/$file ]] && cp -r "$HOME"/$file/ "$HOME"/dotOld/;
			cp -r $dotconfs/$file $HOME;
		fi
	done

	# remove repo
	rm -rf "$HOME"/dotfileBackup;
	old=$(ls -A $HOME/dotOld);
	# get backups on one line
	backups=$(echo $backups | sed 's/\n/ /')
	echo "files:" $old;
	echo "were backed up in" $HOME/dotOld;
	echo "dotFiles: $backups";
	echo "were installed in" $HOME;
else
	echo "Git not installed. Fatal Error, exiting.";
	rm -r "$HOME"/dotOld;
	exit 1;
fi	

