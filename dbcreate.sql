create database d01scvd1
        automatic storage yes
        on '/db/DBSPACE001'
        dbpath on '/db/dbpath'
        using codeset 1252 territory au
        collate using system
        pagesize 4096
        dft_extent_sz 32

        catalog tablespace managed by system
         using ('/db/DBSPACE001/d01scvi1/d01scvd1/syscatspace')
         extentsize 32
         overhead 7.500000
         transferrate 0.060000
         no file system caching

        temporary tablespace managed by system
         using ('/db/WKSPACE001/d01scvi1/d01scvd1/tempspace1/con00001',
                '/db/WKSPACE001/d01scvi1/d01scvd1/tempspace1/con00002',
                '/db/WKSPACE001/d01scvi1/d01scvd1/tempspace1/con00003',
                '/db/WKSPACE001/d01scvi1/d01scvd1/tempspace1/con00004')
         extentsize 32
         overhead 7.500000
         transferrate 0.060000
         file system caching

        user tablespace managed by system
         using ('/db/DBSPACE001/d01scvi1/d01scvd1/userspace1')
         extentsize 32
         overhead 7.500000
         transferrate 0.060000
         no file system caching

;
connect to d01scvd1;

commit work;

connect reset;

terminate;
