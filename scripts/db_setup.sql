CREATE DATABASE hrsystem;
insert into hrsystem.companies (companyuid,companyId,companyName,companyImg,createdAt,updatedAt) values (1,'teknest','Teknest','teknest.gif',now(),now())


insert into hrsystem.pageaccesses(pageId,createdAt,updatedAt,CompanyId) values (1,now(),now(),1)
insert into hrsystem.pageaccesses(pageId,createdAt,updatedAt,CompanyId) values (2,now(),now(),1)	

insert into hrsystem.roles(roleName,roleDescr,createdAt,updatedAt,CompanyId) values ('Employee','Common for all employees',now(),now(),1) 
insert into hrsystem.roles(roleName,roleDescr,createdAt,updatedAt,CompanyId) values ('Hiring Admin','Add new employees to System',now(),now(),1) 

insert into hrsystem.pageaccessesroles (createdAt,updatedAt,PageAccessId,RoleId) values (now(),now(),1,2)
