param (
    [string]$Action,
    [string]$GroupName,
    [string]$UserName,
    [string]$PolicyName,
    [string]$OUPath,
    [string]$NewPassword,
    [string]$NewUserName,
    [string]$FirstName,
    [string]$LastName,
    [string]$Email
)


function Add-NewUser {
    param (
        [string]$NewUserName,
        [string]$FirstName,
        [string]$LastName,
        [string]$Email,
        [string]$Password,
        [string]$OUPath
    )
    try {

        $pass = ConvertTo-SecureString $Password -AsPlainText -Force
        
        New-ADUser -Name "$FirstName $LastName" `
                   -GivenName $FirstName `
                   -Surname $LastName `
                   -SamAccountName $NewUserName `
                   -UserPrincipalName "$NewUserName@yourdomain.com" `
                   -Path $OUPath `
                   -AccountPassword $pass `
                   -PassThru `
                   -Enable $true `
                   -EmailAddress $Email `
                   -Description "Created by PowerShell script" 
        Write-Host "User '$NewUserName' has been created in OU '$OUPath'."
        
    } catch {
        Write-Error "Failed to create user '$NewUserName'. Error: $_"
    }
   }

function Add-UserToGroup {
    param (
        [string]$GroupName,
        [string]$UserName
    )
    try {
        $group = Get-ADGroup -Identity $GroupName -ErrorAction Stop
        $user = Get-ADUser -Identity $UserName -ErrorAction Stop

        Add-ADGroupMember -Identity $GroupName -Members $UserName
        Write-Host "User '$UserName' has been added to group '$GroupName'."
    } catch {
        Write-Error "Failed to add user '$UserName' to group '$GroupName'. Error: $_"
    }
}

function Remove-UserFromGroup {
    param (
        [string]$GroupName,
        [string]$UserName
    )
    try {
        $group = Get-ADGroup -Identity $GroupName -ErrorAction Stop
        $user = Get-ADUser -Identity $UserName -ErrorAction Stop

        Remove-ADGroupMember -Identity $GroupName -Members $UserName -Confirm:$false
        Write-Host "User '$UserName' has been removed from group '$GroupName'."
    } catch {
        Write-Error "Failed to remove user '$UserName' from group '$GroupName'. Error: $_"
    }
}

function Set-GroupPolicy {
    param (
        [string]$GroupName,
        [string]$PolicyName,
        [string]$OUPath
    )
    try {
        $group = Get-ADGroup -Identity $GroupName -ErrorAction Stop
        $gpo = Get-GPO -Name $PolicyName -ErrorAction Stop

        Set-GPLink -Name $PolicyName -Target $OUPath -LinkEnabled Yes
        Write-Host "Policy '$PolicyName' has been applied to OU '$OUPath' for group '$GroupName'."
    } catch {
        Write-Error "Failed to set policy '$PolicyName' for group '$GroupName'. Error: $_"
    }
}

function Set-Password {
    param (
        [string]$UserName,
        [string]$NewPassword
    )
    try {
        $user = Get-ADUser -Identity $UserName -ErrorAction stop
        $password = ConvertTo-SecureString $NewPassword -AsPlainText -Force

        Set-ADAccountPassword -Identity $UserName -NewPassword $password -Reset
        Write-Host "Password for '$user' sucessfully updated."
    } catch {
        Write-Error "Failed to updated password for '$user'. Error: $_"
    }
}

switch ($Action.ToLower()) {
    "add" {
        Add-UserToGroup -GroupName $GroupName -UserName $UserName
    }
    "remove" {
        Remove-UserFromGroup -GroupName $GroupName -UserName $UserName
    }
    "setpolicy" {
        Set-GroupPolicy -GroupName $GroupName -PolicyName $PolicyName -OUPath $OUPath
    }
    "setpassword" {
        set-Password -UserName $UserName -NewPassword $NewPassword
    }
    default {
        Write-Error "Invalid action specified. Use 'add', 'remove', or 'setpolicy'."
    }
}
