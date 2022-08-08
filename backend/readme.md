# Code Setup 
1. Clone the repo
```
git clone https://gitlab.com/tdl-capstone-project/de-b1.git
```
2. Checkout to dev branch
3. Create new branch from dev based upon the functionality you are working.
   1. Branch Naming should be - `Function_Feature_Backend`.
   2. Example of branch - `Login_Auth_Backend`.
4. Click on `gradle.build.kts` and link project to your service folder.
5. Go to `application.conf` file and add your mongo connection string and database name.
6. Start Coding!


## Before Pushing Code - 
1. Get the latest pull from dev branch in your branch.
2. Remove the mongo connection string from `application.conf` file.
3. Test your code locally 
4. Add a descriptive commit message
5. Push the code


## For raising MR - 
1. Check your code locally.
2. Get the latest pull from dev branch in your branch.
3. Raise MR and write a small description about the MR.
4. Get Peer reviewed.
5. Contact one of the Backend Maintainers for merging.



