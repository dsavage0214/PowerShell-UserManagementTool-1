#Check if running as admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 0
}

do{
    Clear-Host
    
    #Display menu
Write-Host "==========================="
Write-Host "     User-Management Tool"
Write-Host "==========================="
Write-Host "1. Create a new user account"
Write-Host "2. List all user accounts"
Write-Host "3. Disable a user account"
Write-Host "4. Enable a user account"
Write-Host "5. Delete a user account"
Write-Host "6. Exit"
Write-Host ""

#Prompt user for input
$choice = Read-Host "Enter your choice (1-6)"

#Perform selected operation
switch ($choice) {
    1 {
        #create a new user
        $username = Read-Host "Please enter your username:"
        $password = Read-Host "Please enter your password:" -AsSecureString
        $fullname = Read-Host "Please enter your full name:"
        try {
        New-LocalUser -Name $username -Password $password -FullName $fullname -ErrorAction Stop
        Write-Host "User '$username' created successfully." -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to create user: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    2 {
        #List all user accounts
        Get-LocalUser | Format-Table Name, FullName, Enabled
    }
    3 {
        #Disable a user account
        $username = Read-Host "Enter the username to be disabled:"
        try {
        Disable-LocalUser -Name $username -ErrorAction Stop
        Write-Host "User '$username' has been disabled." -ForegroundColor Yellow
        }
        catch {
            Write-Host "Failed to disable user: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    4 {
        #Enable a user account
        $username = Read-Host "Enter the username to be enabled:"
        try {
        Enable-LocalUser -Name $username -ErrorAction Stop
        Write-Host "User '$username' has been enabled." -ForegroundColor Green
    }
    catch {
            Write-Host "Failed to enable user: $($_.Exception.Message)" -ForegroundColor Red
        }
}
    5 {
        #Delete a user account
        $username = Read-Host "Enter the username to be deleted (Warning: This action cannot be undone):"
        try{
        Remove-LocalUser -Name $username -ErrorAction Stop
        Write-Host "User '$username' has been deleted." -ForegroundColor Red
        }
        catch {
            Write-Host "Failed to delete user: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    6 {
        #Exit the script
        Write-Host "Exiting..." -ForegroundColor Cyan
        exit 0
    }
    default {
        #if the user enters an invalid option
        Write-Host "Invalid Choice. Please try again:" -ForegroundColor Red
    }
}

if ($choice -ne 6) {
    Write-Host ""
    Read-Host "Press Enter to continue..."
}
 
} 
while ($choice -ne 6)