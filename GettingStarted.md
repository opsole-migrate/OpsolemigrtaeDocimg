# Getting Started with Opsole Migrate

Welcome to **Opsole Migrate** — your comprehensive solution for modern device migration. Whether you’re preparing for a cloud-first future or managing complex merger and acquisition scenarios, Opsole Migrate is purpose-built to simplify and secure the transition process.

This guide will introduce the key features of Opsole Migrate, help you prepare the required environment, and walk you through the steps to execute secure, seamless device migrations with confidence.

With Opsole Migrate, you can:

- ✅ Migrate devices from **Local Active Directory Join** to **Microsoft Entra Join**
- ✅ Convert **Hybrid Entra Joined** devices to **Cloud-Only Entra Join**
- ✅ Perform **cross-tenant device migrations** — ideal for **Mergers, Acquisitions, and Divestitures**

All without:

- Reimaging or wiping devices  
- Losing user profiles, configurations, or local data  
- Interrupting users — even with BitLocker enabled  

---

# 1. Prerequisites for Using Opsole Migrate

Before deploying Opsole Migrate, ensure that the following prerequisites are met across both the source and destination tenants. Meeting these requirements is essential to ensure a smooth and secure migration process.

---

## 1.1 Microsoft Licensing Requirements

Each user involved in the migration process must be assigned the appropriate Microsoft licenses.

**Required Licenses:**

- **Microsoft Intune**  
  - Standalone license OR included in Microsoft 365 E3/E5
- **Microsoft Entra ID P1 or P2**  
  - Standalone license OR included in Microsoft 365 E3/E5

> **Note:** Licenses must be active and assigned before migration.

---

## 1.2 Supported Device Management States

Devices targeted for migration must be in one of the following states:

- Microsoft Entra ID Joined  
- Hybrid Entra ID Joined  
- Active Directory Domain Joined  
- MECM/SCCM Managed or Co-managed  
- Fully Intune Managed  

> **Important:** Devices that are unmanaged (i.e., not enrolled in Intune or MECM) will require an alternate deployment method for the Opsole Migrate application..

---

## 1.3 PC Technical Requirements

To ensure compatibility and optimal performance during the migration process, all client devices must meet the following minimum hardware and software requirements:

| Specification | Minimum Requirement |
|--------------|---------------------|
| OS Version | Windows 10/11 (Build 22H2 or later) |
| RAM | 8 GB |
| Storage | 256 GB SSD |
| Processor | 64-bit CPU with 2+ cores (4 recommended) |
| TPM | Version 2.0 or higher |
| Connectivity | Stable internet connection |

> Devices not meeting these minimum specifications may experience performance degradation or compatibility issues during migration..

---

## 1.4 Network Requirements

To enable a smooth and uninterrupted migration experience, the network used by devices must meet the following requirements:

- Support **HTTPS port 443**
- Does not require user authentication or use a proxy that requires user authentication
- Allows outbound access to the following Microsoft and Opsole service endpoints:
  - https://.manage.microsoft.com
  - https://.manage.microsoftazure.us
  - https://.manage.microsoftazure.us
  - https://.manage.microsoftazure.us
  - https://.msazure.cn
  - https://.microsoftonline.com
  - https://.microsoftonline-p.com
  - https://.microsoftonline.us
  - https://.microsoftonline.de
  - https://.microsoftonline.cn
  - https://*.opsole.com


> Ensure that firewall rules, proxy configurations, and DNS filtering policies do not block access to any of the above domains.

---

## 1.5 Access and Configuration Requirements

To successfully deploy and manage migrations using Opsole Migrate, specific access permissions and configuration settings are required within Microsoft Entra ID, Active Directory, and Microsoft Intune.

### Microsoft Entra ID
Global Administrator privileges are required in both the source and destination tenants to:

- Register applications in Microsoft Entra ID
- Generate client secrets
- Assign and consent to required Microsoft Graph API permissions

### Active Directory – Access Requirements
- An account with delegated permissions to disjoin devices from Active Directory

### Microsoft Entra ID & Intune – Configuration Requirements

| Setting | Recommended |
|---------|-------------|
| Automatic Enrollment (User Scope) | **All** |
| Allow users to join devices to Entra | **Enabled** |
| Require MFA for join/register devices | **NO** |
| Conditional Access Policies | Exclude **Package_Account** (used for bulk provisioning) |

> Misconfiguration of these settings may prevent device registration or enrollment during the migration process.

---

## 1.6 Required Graph API Permissions

The following application-level Microsoft Graph API permissions must be granted to the Opsole Migrate application in both source and destination tenants. These permissions enable critical operations such as device management, user attribute access, and policy enforcement.

| Permission | Type | Purpose |
|------------|------|----------|
| Device.ReadWrite.All | Application | Update Autopilot group tags |
| DeviceManagementManagedDevices.ReadWrite.All | Application | Set primary user / delete Intune object |
| DeviceManagementServicesConfig.ReadWrite.All | Application | Autopilot management |
| User.Read.All | Application | Read user attributes |
| Directory.Read.All | Application | Read directory data |
| DeviceManagementConfiguration.ReadWrite.All | Application | Manage policies |
| DeviceLocalCredential.Read.All | Application | Retrieve local credential passwords |
| DeviceLocalCredential.ReadBasic.All | Application | Retrieve credential metadata |

> These permissions require **Admin Consent** during the application registration process in Microsoft Entra ID.

---

## 1.7 Additional Tools Required

To support device preparation and application deployment during the migration process, the following tools are required:

- **Windows Configuration Designer (WCD)**  
  Used to streamline Windows device provisioning and create provisioning packages for bulk enrollment.  
  👉 Download from Microsoft Store

- **Microsoft Win32 Content Prep Tool**  
  Prepares Windows application packages in  .intunewin format for deployment via Microsoft Intune. 
  👉 Download from Microsoft Learn

---

# 2. Deployment Procedure

---

## 2.1 Migration Source Files

To obtain the latest Opsole Migrate Installation Files from your Opsole Customer Portal. 
- Navigate to **Settings** > **Downloads Center** section to download the migration setup file (MSI).

![Migration Source Files](https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/sourcefile.png)

This files include the application installer and supporting components necessary for executing migrations.

---

# 2.2 Phase 1: Pre-Migration Activities

---

## Step 1: Validate Prerequisites

Before proceeding, confirm that all requirements have been met:

- Microsoft licensing and tenant access rights
- Supported device states and technical specifications
- Network connectivity and Graph API permissions
- Required tools (e.g., Windows Configuration Designer, Win32 Content Prep Tool)

Refer to Section 1: Prerequisites for complete details.


---

## 2.2.1 Application Registration in Microsoft Entra ID

You will register a new application in each source and destination tenant to enable API access.

- Go to entra.microsoft.com and sign in with Global Administrator credentials,

### Step 1 — Register Application
1. Go to **entra.microsoft.com**
2. Navigate to:  
   **Home → Applications → App registrations**
3. Click **+ New registration**

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/1.png" >

4. Enter a name for the application (for example, OpsoleMigrateApp). Retain all other settings at their default values.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/2.png" >

5. Click **Register**

### Step 2 — Save Identifiers
From the application’s Overview page, copy and save the following:

- Application (Client) ID  
- Directory (Tenant) ID  

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/3.png" >

### Step 3 — Add API Permissions

1. Go to **API permissions** > Click **+ Add a permission**

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/4.png" >


2. On the Request API permissions page, select **Microsoft Graph**

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/5.png" >

3. Select Application permissions

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/6.png" >

4. Use the search bar to add the following permissions:

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/7.png" >

| Permission | Type |
|------------|------|
| Device.ReadWrite.All | Application |
| DeviceManagementManagedDevices.ReadWrite.All | Application |
| DeviceManagementServicesConfig.ReadWrite.All | Application |
| User.Read.All | Application | 
| Directory.Read.All | Application | 
| DeviceManagementConfiguration.ReadWrite.All | Application | 
| DeviceLocalCredential.Read.All | Application | 
| DeviceLocalCredential.ReadBasic.All | Application | 

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/8.png" >


5. Click 5.	After adding the permissions, click **Grant admin consent** for [TENANT NAME]. Click Yes at the Grant admin consent confirmation popup.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/9.png" >

6. All permissions should now display a status of Granted for [TENANT NAME]

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/10.png" >

### Step 4 — Generate Client Secret

1. Go to **Certificates & secrets → Client secrets**
2. Click **+ New client secret**

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/11.png" >

3. Fill in the following:
     - Description: (e.g., OpsoleSecretKey)
    - Expires: Select a duration (e.g., 180 days recommended)

4. Click **Add**

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/12.png" >

### Step 5: Save the Secret Value

- Copy the Value of the new secret immediately and save it securely.
> This is the only time the secret value will be visible. Do not navigate without saving it.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/13.png" >

---

## 2.2.2 Provisioning Package Preparation (WCD)

In order to facilitate device registration and migration, it is necessary to generate a provisioning package with the Windows Configuration Designer (WCD) tool.

### Step 1 — Download Windows Configuration Designer (WCD) 
Download and install the Windows Configuration Designer from the Microsoft Store:

> The Microsoft Store is required to be accessible on the PC designated for provisioning package creation. This process constitutes a one-time setup that is generally completed on the IT administrator’s workstation

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/14.png" >

### Step 2 — Launch Windows Configuration Designer  
Open the Start menu and launch Windows Configuration Designer.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/15.png" >

### Step 3 — Create New Project  

1. In the WCD home screen, select "Provision desktop devices" under the Create menu.
2.	In the New project popup:
   - Enter a name for your provisioning package and path.
   - Click Finish

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/16.png" >  


### Step 4 — Configure Device Settings

1.	Under Set up device, define a naming template for your PCs (e.g., IT-{SERIAL})
2.	Click Next

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/17.png" > 

3.	In Set up network, toggle "Connect device to a Wi-Fi network" to Off
4.	Click Next

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/18.png" > 

### Step 4 — Enroll with Bulk Azure AD Token 

1.	Under Account Management, do the following:
    - Choose Enroll in Azure AD under Manage organization/school accounts.
    - Toggle "Refresh AAD credentials" to Yes.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/19.png" > 

2.	Click Get Bulk Token and sign in with Global Admin credentials when prompted.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/20.png" > 

3.	If this is your first time using WCD:
    - You will see a permissions consent screen.
    - Click "Consent on behalf of your organization.”
    - Then click Accept.

    <img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/21.png" > 

4. You should see a confirmation message
✅ Bulk token was fetched successfully

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/22.png" > 

### Step 5 - Complete the Package

1.	Skip the Add applications and Add certificates screens by clicking Next.
2.	On the Summary screen, verify all configuration details.
> If you wish to retain the existing PC name post-migration, skip this Create step and refer to Step 6 below.
3.	Click Create
4.	After creation, a file path to the .ppkg file will be displayed.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/23.png" > 

### Step 6: (Optional) Remove Computer Name from Package
If you need to retain the existing computer name after migration:
1.	In WCD, click "Switch to advanced editor."

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/24.png" > 

2.	Search for Computer name object 
3.	On the right-hand side panel, (under Runtime settings > Identification), Select DNSComputerName
4.	click Remove

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/26.png" > 

5.	The computer name setting will now be excluded from the package.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/27.png" > 

### Step 7: Export the Final Provisioning Package
1.	Click Export > Provisioning package.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/28.png" > 

2.	Enter a file name, then click Next

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/29.png" > 

3.	Leave security settings as default, click Next

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/30.png" > 

4.	Choose the destination folder, then click Next

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/31.png" > 

5.	Click Build

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/32.png" > 

You will see a confirmation message:
- ✅ Provisioning package has been successfully saved and the location.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/33.png" > 
---

## 2.2.3 Active Directory Device Disjoin Account Preparation

To facilitate the disjoining of devices from a Local Active Directory (AD) domain during migration, it is necessary to establish a dedicated standard user account with delegated permissions. This account will be utilized by the Opsole Migrate agent to execute disjoin operations on the targeted devices.

### Step 1 — Create Delegated AD Account

1.	On your domain controller, open the Active Directory Users and Computers console (dsa.msc)
2.	Create a new user account within your designated Organizational Unit (OU).
    - Set a Strong password for the account.
    - Verify that the account is not subject to any Group Policy Objects (GPOs) or security policies that might restrict remote access.
    - Confirm the account can log in remotely to domain-joined PCs

### Step 2 — Delegate Control to the Computers OU

1.	In Active Directory Users and Computers, navigate to the OU that contains the computers targeted for migration.
2.	Right-click the OU and select "Delegate Control..."
3.	In the Delegation of Control Wizard:

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/34.png">  

- Select the user account you created in Step 1 and Click Next

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/35.png">

4.	On the Tasks to Delegate screen:
-	Choose "Create a custom task to delegate.”
-	Click Next

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/36.png">

5.	In the Active Directory Object Type window:
  - Select "Only the following objects in the folder.”
  - Check:
    - ✅ Computer objects
    - ✅ Create selected objects in this folder
    - ✅ Delete selected objects in this folder

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/37.png">

6.	In the Permissions window:
- Select:
    - ✅ General
    - ✅ Property-specific
    - ✅ Creation/deletion of specific child objects
- Under Permissions, check the following:
    - ✅ Delete All Child Objects
    - ✅ Read All Properties
    - ✅ Write All Properties
    - ✅ Reset Password

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/38.png">

7.	Click Next, review your settings and Finish to complete the delegation.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/39.png">

✅ The user account now has the required delegated rights to disjoin computer objects from Active Directory.


---

# 2.3 Opsole Migrate Portal Setup

After completing all prerequisite configurations, you're ready to set up the Opsole Migrate Portal. This step involves registering your tenant and applying the configuration values gathered during the previous setup phases.

## Step 1: Access the Opsole Migrate Portal
1.	Navigate to Opsole Migrate portal URL provided to you during your Opsole Migrate license activation.
2.	Log in using the credentials provided. 
3.  Set Migration Configuration
> (e.g., “AD Joined Device to Entra ID or Hybrid Joined Device to Entra ID”)
4.	In the Source Tenant section, enter the following values (retrieved during application registration):
    - Client ID
    - Client Secret
    - Tenant ID
    - Tenant Name
5.	Click Verify, Opsole Migrate will automatically validate the credentials and configuration.
6.	Save Configuration

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/40.png">

## Step 2: Additional Configuration
After successfully saving your Entra ID configuration, proceed to complete the Additional Configuration settings:

2.	Fill in the following fields as needed for your migration scenario:
    - Domain: Enter your organization’s domain name
    - Domain leave User / Password: “FQDN\Username” and password
    - Group (Autopilot Devices): Specify the group, if applicable, to manage devices provisioned through Autopilot
    - BitLocker Migrate Option: MIGRATE or DECRYPT based on whether you want to retain BitLocker encryption during migration.
    - Device Attributes: Select device attributes to be retained or modified.
    - Target Group (Post-Migration): Define the destination group to which devices should be assigned after migration.

- Click Save to apply the settings.

<img src= "https://raw.githubusercontent.com/sreekumarpg/OpsolemigrtaeDoc/refs/heads/main/40.png">

## Step 3: Provisioning package

To upload the provisioning package for the migration process, follow these steps:

- Navigate to **Settings** > **Configuration**
- Locate the Package section
- Click Upload Package
- Upload the Provisioning package

✅ Your configuration is now complete. You are ready to begin the Opsdole Migrate application and Start Your Migration

---
