CREATE DATABASE hrsystem;
use hrsystem;
insert into hrsystem.companies (companyuid,companyId,companyName,companyImg,createdAt,updatedAt) values (1,'teknest','Teknest','teknest.gif',now(),now());

insert into hrsystem.pageaccesses (pageId,createdAt,updatedAt,CompanyId) values (1,now(),now(),1);
insert into hrsystem.pageaccesses (pageId,createdAt,updatedAt,CompanyId) values (2,now(),now(),1);
insert into hrsystem.pageaccesses (pageId,createdAt,updatedAt,CompanyId) values (3,now(),now(),1);
insert into hrsystem.pageaccesses (pageId,createdAt,updatedAt,CompanyId) values (4,now(),now(),1);
insert into hrsystem.pageaccesses (pageId,createdAt,updatedAt,CompanyId) values (5,now(),now(),1);
insert into hrsystem.pageaccesses (pageId,createdAt,updatedAt,CompanyId) values (1000,now(),now(),1);
insert into hrsystem.pageaccesses (pageId,createdAt,updatedAt,CompanyId) values (1001,now(),now(),1);

insert into hrsystem.roles (roleName,roleDescr,createdAt,updatedAt,CompanyId) values ('Admin','This User has access to all pages',now(),now(),1);
insert into hrsystem.roles (roleName,roleDescr,createdAt,updatedAt,CompanyId) values ('My Tasks','This Employee has access to pages under Employee Management',now(),now(),1);

insert into hrsystem.pageaccessesroles (createdAt,updatedAt,PageAccessId,RoleId) values (now(),now(),1,1);
insert into hrsystem.pageaccessesroles (createdAt,updatedAt,PageAccessId,RoleId) values (now(),now(),2,1);
insert into hrsystem.pageaccessesroles (createdAt,updatedAt,PageAccessId,RoleId) values (now(),now(),3,1);
insert into hrsystem.pageaccessesroles (createdAt,updatedAt,PageAccessId,RoleId) values (now(),now(),4,1);
insert into hrsystem.pageaccessesroles (createdAt,updatedAt,PageAccessId,RoleId) values (now(),now(),5,1);
insert into hrsystem.pageaccessesroles (createdAt,updatedAt,PageAccessId,RoleId) values (now(),now(),1000,2);
insert into hrsystem.pageaccessesroles (createdAt,updatedAt,PageAccessId,RoleId) values (now(),now(),1001,2);

insert into hrsystem.users (uuid,signInId,email,firstName,middleName,lastName,createdAt,updatedAt,CompanyId,isAccountActive)values(1,'sathya','sathyavikram@gmail.com','sathya','vikram','chekuri',now(),now(),1,true);
insert into hrsystem.employees(emplid,createdAt,updatedAt,CompanyId,UserId) values (1,now(),now(),1,1);
	
insert into hrsystem.rolesusers (createdAt,updatedAt,RoleId,UserId) values (now(),now(),1,1);