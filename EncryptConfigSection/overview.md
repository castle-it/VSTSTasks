# Encrypt Config File
**Encrypt section of Config File Using aspnet_regiis.**

**_Usages:_**

Use this task to encrypt your configuration file using aspnet_regiis.:
** 1. Predefined section like “ConnectionString” **
** 2. Alternatively, Any Custom section defined in configuration file.**

**_Installation:_**

After successful integration/installation of extension, you should be able see task under “Add task” list as follow:

![AddTask](https://raw.githubusercontent.com/JawedCIA/VSTSTasks/master/EncryptConfigSection/images/Add-Task.PNG)

**_Discription:_**

Full display of "EncryptConfig" Task under Release Group.

![](https://raw.githubusercontent.com/JawedCIA/VSTSTasks/master/EncryptConfigSection/images/Task-UI.PNG)

| Parameters |Type| Description |
| :---         |     :---:      |         :--- |
| 1. Config File Path |filePath| Folder Path of Config file to be Encrypted |
| 2. Config File To Be Encrypt | string | Config file to be Encrypted(*.config) |
| 3. Encryption Provider To Use | pickList | Protection Provider to use for Encryption(DataProtectionConfigurationProvider or RsaProtectedConfigurationProvider). |
| 4. Section of Config file to be Encrypted| string | Section of Config file to be Encrypted(e.g ConnectionStrings) |
| 5. Recursive? | boolean | Mark this boolean field to make search recursive, that is, to apply the encryption to all the files matching the pattern including sub folders. Unmark the field if the file search should not be recursive: in this case, web.config files in the sub folders will not be considered for encryption for the pattern web.config. |


**_Advanced: For Custome Section Encryption:_**

Use this option to in case you want to Encrpt any custom section of configuration file.

![](https://raw.githubusercontent.com/JawedCIA/VSTSTasks/master/EncryptConfigSection/images/Advance.PNG)


Expand Advanced option,

| Parameters |Type| Description |
| :---         |     :---:      |         :--- |
| 1. Comment Section of Config|pickList|Check this option in case you want to comment section of config before Encrytion. |
| 2. Section from config to comment Before Encryption|multiLine|Section from config to comment Before Encryption. |

```
Note: Logical workflow during an encryption to custom section,
1. comment the custome section mentioned under settingsconfigSections
2. Perform encryption of custome section
3. Uncomment the custome section
```

**_Information: Data Protection provide for encryption_**
Using this task you can use DataProtection Configuration Provider "or" RsaProtected Configuration Provider.
![](https://raw.githubusercontent.com/JawedCIA/VSTSTasks/master/EncryptConfigSection/images/Provider.PNG)

To log any issue use [GitHub Pages](https://github.com/JawedCIA/VSTSTasks/issues).
