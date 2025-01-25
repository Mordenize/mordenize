## Introduction 
- CMS manage blogs
- Most important in this project is working with AWS like EC2, S3, VPC, Cloudfront...

## Technology  
- Laravel 11 
- Docker
- CI/CD (Git Actions, Git hooks): 
    + Checking commit rules by Conventional Commits
    + Checking PHP scripts by PHPMD/PHDCS

## Database 
```mermaid
erDiagram
    USERS {
        int ID PK 
        string(99) name 
        string(99) email
        datetime email_verified_at
        string(199) password
        tinyint(1) role 
        string(100) remember_token
        datetime created_at 
        int created_by 
        datetime updated_at
        int updated_by
        datetime deleted_at
    }

    NEWS {
        int ID PK 
        int user_id FK
        string(99) title
        text body
        date publish_at
        datetime created_at 
        int created_by 
        datetime updated_at
        int updated_by
        datetime deleted_at
    }

    USERS ||--o{ NEWS : postMany
```
