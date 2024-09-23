# Active Directory Management Script

This PowerShell script automates various Active Directory (AD) tasks, including managing users, groups, and policies. The script provides several functions that streamline the process of adding, removing, and modifying AD objects.

## Features

- **Add New User**: Create a new user with specified details, including username, email, and password.
- **Add User to Group**: Add a specified user to an existing AD group.
- **Remove User from Group**: Remove a specified user from an AD group.
- **Set Group Policy**: Apply a Group Policy Object (GPO) to a specified group within an Organizational Unit (OU).
- **Set Password**: Change the password for a specified user.

## Functions

### 1. Add-NewUser
Creates a new user in Active Directory.

**Parameters:**
- `NewUserName`: The username of the new user.
- `FirstName`: The first name of the user.
- `LastName`: The last name of the user.
- `Email`: The user's email address.
- `Password`: The password for the new user.
- `OUPath`: The path to the OU where the user will be created.

### 2. Add-UserToGroup
Adds a specified user to an existing AD group.

**Parameters:**
- `GroupName`: The name of the group.
- `UserName`: The username of the user.

### 3. Remove-UserFromGroup
Removes a specified user from an existing AD group.

**Parameters:**
- `GroupName`: The name of the group.
- `UserName`: The username of the user.

### 4. Set-GroupPolicy
Applies a Group Policy Object (GPO) to a group within an OU.

**Parameters:**
- `GroupName`: The name of the AD group.
- `PolicyName`: The name of the policy to be applied.
- `OUPath`: The path to the OU where the policy will be linked.

### 5. Set-Password
Changes the password for a specified user.

**Parameters:**
- `UserName`: The username of the account.
- `NewPassword`: The new password for the user.

## Usage
To use the script, run it with the appropriate parameters for the desired function. Ensure you have the necessary permissions to perform AD modifications.
