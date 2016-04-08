# OH HEY! Welcome to your new project.

One of your teammates should clone this repository to their machine. Then, go through these steps:

1. Add a `.gitignore` to the cloned directory. The [Github suggested one for Objective-C](https://github.com/github/gitignore/blob/master/Objective-C.gitignore) is a good start.
2. Uncomment the `Pods/` line in the `.gitignore`. We want to ignore the Pods directory. Trust me on this.
3. Add a line that just says `Secrets.m` (or `Constants.m`, your preference) to the `.gitignore`. We want git to ignore your API keys and secrets, since this is going to be open source.
4. Make a new Xcode project in the cloned directory.
5. Run `pod init` in the directory, and add a pod (any pod) to the `Podfile`. Then run `pod install`. This will set up the workspace for the project, so everyone starts on the same foot.
6. Add `Secrets.h` and `Secrets.m` files to your project (using `File > New > Cocoa Class`).
7. In terminal, you'll probably need to do `git reset HEAD` and then `git add .`. This is just necessary when making changes to the `.gitignore`.
8. Once you've done that, run `git status` and ensure that the `Secrets.m` file and `<username>.xcuserdata` files are **not** in the list.
9. Commit! `git commit -m "Initial Commit"`
10. Push! `git push origin master`

Now your teammates can clone this repository and start branching and coding!

# Basic Git Merge Procedure 
Any time you’re wanting to move your stuff into Master, do these steps: (adapted from pinned post on Slack)

1. Make sure on your local branch you added, committed and pushed any changes first
2. Checkout to Master branch
3. `git pull` <— on the Master branch you should currently be on
4. Now checkout back to your other branch
5. Then type `git merge master` <— this will merge Master wherever it currently stands INTO your local branch. Fix any conflicts here
6. To fix conflicts, you can open the file and make any changes… or type `git checkout —-theirs FILENAME`or `git checkout —-ours FILENAME` to tell git to JUST Keep either OURS which is the current branch your own or THEIRS which is the branch you’re trying to merge into yours. This keeps one or the other where you don’t then have to review the files. This is especially useful for Storyboard files.
7. Then go back to Master
8. Then merge your local branch into master (you should have no conflicts because of the prior steps)
9. Let your team know that Master has now changed
