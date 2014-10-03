CREATE DATABASE hrsystem;
use hrsystem;
insert into hrsystem.Companies (companyuid,companyId,companyName,companyImg,createdAt,updatedAt) values (1,'teknest','Teknest','teknest.gif',now(),now());

insert into hrsystem.PageAccesses (pageId,createdAt,updatedAt,CompanyId) values (1,now(),now(),1);
insert into hrsystem.PageAccesses (pageId,createdAt,updatedAt,CompanyId) values (2,now(),now(),1);
insert into hrsystem.PageAccesses (pageId,createdAt,updatedAt,CompanyId) values (3,now(),now(),1);
insert into hrsystem.PageAccesses (pageId,createdAt,updatedAt,CompanyId) values (4,now(),now(),1);
insert into hrsystem.PageAccesses (pageId,createdAt,updatedAt,CompanyId) values (5,now(),now(),1);
insert into hrsystem.PageAccesses (pageId,createdAt,updatedAt,CompanyId) values (6,now(),now(),1);
insert into hrsystem.PageAccesses (pageId,createdAt,updatedAt,CompanyId) values (7,now(),now(),1);
insert into hrsystem.PageAccesses (pageId,createdAt,updatedAt,CompanyId) values (8,now(),now(),1);	
insert into hrsystem.PageAccesses (pageId,createdAt,updatedAt,CompanyId) values (1000,now(),now(),1);
insert into hrsystem.PageAccesses (pageId,createdAt,updatedAt,CompanyId) values (1001,now(),now(),1);
insert into hrsystem.PageAccesses (pageId,createdAt,updatedAt,CompanyId) values (1002,now(),now(),1);

insert into hrsystem.Roles (roleId,roleName,roleDescr,createdAt,updatedAt,CompanyId) values (1,'Admin','This User has access to all pages',now(),now(),1);
insert into hrsystem.PageAccessesRoles (createdAt,updatedAt,PageAccessId,RoleId) values (now(),now(),1,1);
insert into hrsystem.PageAccessesRoles (createdAt,updatedAt,PageAccessId,RoleId) values (now(),now(),6,1);

insert into hrsystem.Users (uuid,signInId,email,firstName,middleName,lastName,createdAt,updatedAt,CompanyId,isAccountActive)values(1,'sathya','sathyavikram@gmail.com','sathya','vikram','chekuri',now(),now(),1,true);
insert into hrsystem.Employees(emplid,createdAt,updatedAt,CompanyId,UserId) values (73,now(),now(),1,1);
insert into hrsystem.RolesUsers (createdAt,updatedAt,RoleId,UserId) values (now(),now(),1,1);