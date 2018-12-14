# Experiment Oscillatory signatures of incidental word learning

Move to the directory in which you would like this Git repository to be cloned
use ```cd``` to move down the directory structure

To clone this repository type in your command window 
```git clone https://github.com/amickan/Experiment_6_Nikita```

Move to the newly created repository by typing
```cd Experiment_6_Nikita```

To create your own branch 
``git checkout -b your_name``

Once you have made changes to files in your branch:
1. Check if you have unstaged changes by entering ``git status``
2. To add new files to the changes you want to commit, enter ``git add file_name``
3. Check whether this worked by again typing ``git status`` (the previously red files should now appear in green)
4. Commit your changes and add an informative message what you changed: ``git commit -m "your informative message"``
5. Push the committed changes to your remote branch: ``git push ``
6. This will prompt your to enter your Github credentials 

To push local changes to master (when you want collaborators to see your changes)
```git push origin master```

When you get back to the project, it is usually good practice to pull the latest version of the master to your branch, to do ``git pull -origin -master``
