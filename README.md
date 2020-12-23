# Configurations and Tricks
My custom configuration scripts and tricks


1. Customise your Bash Prompt

    <img src="bash/custom_bash_prompt.png" target="bash/custom_prompt.sh">

    - To apply this theme open your bash config
    ```bash
    nano ~/.bashrc
    # you may use any text editor e.g - vim
    vim ~/.bashrc
    ```
    - Copy the contents of [custom_prompt.sh](custom_prompt.sh) to the end of `.bashrc`.
    - Save config file and exit
    ```bash
    # for nano 
    Ctrl + O 
    Enter
    Ctrl + X
    # for vim
    :w
    :q
    ```
    - Relaunch terminal or run following command
    ```bash
    source ~/.bashrc
    ```
    - You can change colors and add others options too, currently it shows *time*, *user@host*, *current directory*, *active git branch*,*conda virtual environment* and cute little emojis showing the success of last command. (😎:😩), Some terminals may not support emojis, replace with :) and :( in that case


2. Customise your PowerShell prompt

    <img src="powershell/custom_prompt.png" target="powershell/profile.ps1">

    - Set script execution policy, open a powershell with admin
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
    ```
    - To apply this prompt you first need to find if there is an existing configuration
    ```powershell
    if (!(Test-Path -Path $PROFILE)){ New-Item -Path $PROFILE -ItemType File } ; notepad $PROFILE
    ```
    - Copy the contents of [profile.ps1](powershell/profile.ps1) to this file, save and exit
    - Relaunch your powershell

3. Rebase and sqash commits of an active pull request (git)

    - Confirm or configure upstream
    ```bash
    # make sure you have a upstream configured, to check type 
    git remote -v
    # result will have origin and upstream as below
        origin  https://github.com/<you>/<repo>.git (fetch)
        origin  https://github.com/<you>/<repo>.git (push)
        upstream        https://github.com/<owner>/<repo>.git (fetch)
        upstream        https://github.com/<owner>/<repo>.git (push)
    ```
    If yes skip next step
    - Add a upstream 
    ```bash
    git remote add upstream https://github.com/<owner>/<repo>.git
    ```
    Again check with previous command
    - Update your fork
    ```bash
    # fetch updates from upstream
    git fetch upstream
    # checkout master or main branch
    git checkout master
    # push update to your fork
    git push
    ```
    - Rebase your pull request, checkout the original branch used to create pull request
    ```bash
    git checkout pull-request-branch
    # rebase this branch
    git rebase upstream/master
    ```
    If you want to sqash your commits then follow the step or skip to last
    - reset last `n` commits
    ```bash
    git reset --soft HEAD~n
    # new sqashed commit
    git commit -m "commit message"
    ```
    - Push your changes
    ```bash
    git push origin +pull-request-branch
    ```
    **+** is required to put before branch name since you are rewriting the history and forcely pushing it

4. Split a commit in already pushed code or active pull request
    - Rebase last `n` commits
    ```bash
    git rebase -i HEAD~n
    ```
    In the interactive screen simply replace *pick* with *edit* in front of the commits you want to modify
    ```bash
    git reset HEAD~
    ```
    - Add your files again and commit 
    ```bash
    git add ...
    git commit -m "commit 1 message"

    git add ...
    git commit -m "commit 2 message"
    .
    .
    git add ...
    git commit -m "last commit message"
    ```
    - Continue rebasing
    ```bash
    git rebase --continue
    ```
    - Push your changes
    ```bash
    git push origin +branch-name
    ```
    
