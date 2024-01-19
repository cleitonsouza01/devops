# Devops tools
I am excited to introduce a comprehensive project designed to significantly enhance the daily operations of various IT professionals, including DevOps engineers, IT service desk personnel, and those involved in automation tasks. The core idea of this initiative is to develop a suite of versatile tools that transcend language barriers, catering to a diverse range of needs and environments.

To achieve this, we will be creating tools in multiple scripting languages, including PowerShell, Python, Windows Batch files, VBS, and others. This multi-language approach ensures that our tools are accessible and adaptable, regardless of the user's preferred programming language or specific IT infrastructure.

Our goal is to simplify and streamline the workflow of IT professionals, making their tasks more efficient and less time-consuming. By providing these comprehensive, language-agnostic tools, we aim to empower IT personnel to focus more on strategic initiatives and less on routine automation challenges.

We look forward to collaborating with IT experts and receiving feedback to continuously refine our offerings and better serve the IT community.

## Use of .env file
To ensure the security and integrity of our project, we are utilizing a .env file, which is a recognized best practice for safeguarding sensitive information. This approach helps prevent the inadvertent exposure of confidential data.

For your convenience, you will find an `.env-example` file included in the repository. This file serves as a template, illustrating the required format that should be used in your own .env file. I encourage you to use this example as a guide to create your personalized `.env` file, adapting it to meet the specific needs and configurations of your environment.

Remember, the `.env` file should never be committed to the version control system to maintain the confidentiality of the sensitive information it contains. Should you have any questions or need further assistance in setting up your .env file, please feel free to reach out.

Included in this repository is a PowerShell script (test-env.ps1) that checks the readability and format of your .env file. Simply run 
``` 
powershell test-env.ps1
```
 to use it. The script will confirm if your .env file is correctly set up, with results displayed as shown below:

 ```
PS C:\Users\cleiton\devops> powershell .\test-env.ps1
Environment variables found in C:\Users\cleiton\devops\.env
GROUPS = "HelpDesk", "Domain Admins", "Finance", "MSCCM - Services"
COMPANY_NAME = Cleiton_Software
ADMIN_USERNAME = supercleiton
PS C:\Users\cleiton\devops>
 ```