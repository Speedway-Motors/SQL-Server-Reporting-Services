select sPhotoPath, sThumbnailPath 
into PJC_PathChangeTest
from tblProductPhoto

select * from PJC_PathChangeTest

/*
sPhotoPath	                                    sThumbnailPath
C:\ProductPhotos\550150\Unedited\1000000.jpg	C:\ProductPhotos\550150\Print\1000127-thumb.jpg
C:\ProductPhotos\550150\Unedited\1000012.jpg	NULL
C:\ProductPhotos\6051675L\Unedited\1000013.jpg	NULL
C:\ProductPhotos\6051675L\Unedited\1000014.jpg	NULL
C:\ProductPhotos\6051675L\Unedited\1000015.jpg	NULL
C:\ProductPhotos\6051675L\Unedited\1000016.jpg	NULL
C:\ProductPhotos\6051675L\Unedited\1000017.jpg	NULL
C:\ProductPhotos\91015124\Unedited\1000018.jpg	NULL
C:\ProductPhotos\91015124\Unedited\1000019.jpg	NULL
C:\ProductPhotos\91015124\Unedited\1000020.jpg	NULL
C:\ProductPhotos\91137057\Unedited\1000021.jpg	NULL
C:\ProductPhotos\91137057\Unedited\1000022.jpg	NULL
C:\ProductPhotos\91137057\Unedited\1000023.jpg	NULL
C:\ProductPhotos\91137057\Unedited\1000024.jpg	NULL
C:\ProductPhotos\91137057\Unedited\1000025.jpg	NULL
C:\ProductPhotos\91076522\Unedited\1000026.jpg	C:\ProductPhotos\91076522\Unedited\1000026-thumb.jpg
C:\ProductPhotos\91076522\Unedited\1000027.jpg	C:\ProductPhotos\91076522\Unedited\1000027-thumb.jpg
C:\ProductPhotos\91076522\Unedited\1000028.jpg	C:\ProductPhotos\91076522\Unedited\1000028-thumb.jpg
*/

UPDATE dbo.tblProductPhoto
SET    sPhotoPath = replace(sPhotoPath, 'C:\ProductPhotos\', '\\GreenDragon\ProductPhotos$\')
WHERE  sPhotoPath LIKE 'C:\ProductPhotos\%'

UPDATE dbo.tblProductPhoto
SET    sThumbnailPath = replace(sThumbnailPath, 'C:\ProductPhotos\', '\\GreenDragon\ProductPhotos$\')
WHERE  sThumbnailPath LIKE 'C:\ProductPhotos\%'

select * from PJC_PathChangeTest

/*
sPhotoPath	sThumbnailPath
\\GreenDragon\ProductPhotos$\550150\Unedited\1000000.jpg	\\GreenDragon\ProductPhotos$\550150\Print\1000127-thumb.jpg
\\GreenDragon\ProductPhotos$\550150\Unedited\1000012.jpg	NULL
\\GreenDragon\ProductPhotos$\6051675L\Unedited\1000013.jpg	NULL
\\GreenDragon\ProductPhotos$\6051675L\Unedited\1000014.jpg	NULL
\\GreenDragon\ProductPhotos$\6051675L\Unedited\1000015.jpg	NULL
\\GreenDragon\ProductPhotos$\6051675L\Unedited\1000016.jpg	NULL
\\GreenDragon\ProductPhotos$\6051675L\Unedited\1000017.jpg	NULL
\\GreenDragon\ProductPhotos$\91015124\Unedited\1000018.jpg	NULL
\\GreenDragon\ProductPhotos$\91015124\Unedited\1000019.jpg	NULL
\\GreenDragon\ProductPhotos$\91015124\Unedited\1000020.jpg	NULL
\\GreenDragon\ProductPhotos$\91137057\Unedited\1000021.jpg	NULL
\\GreenDragon\ProductPhotos$\91137057\Unedited\1000022.jpg	NULL
\\GreenDragon\ProductPhotos$\91137057\Unedited\1000023.jpg	NULL
\\GreenDragon\ProductPhotos$\91137057\Unedited\1000024.jpg	NULL
\\GreenDragon\ProductPhotos$\91137057\Unedited\1000025.jpg	NULL
\\GreenDragon\ProductPhotos$\91076522\Unedited\1000026.jpg	\\GreenDragon\ProductPhotos$\91076522\Unedited\1000026-thumb.jpg
\\GreenDragon\ProductPhotos$\91076522\Unedited\1000027.jpg	\\GreenDragon\ProductPhotos$\91076522\Unedited\1000027-thumb.jpg
\\GreenDragon\ProductPhotos$\91076522\Unedited\1000028.jpg	\\GreenDragon\ProductPhotos$\91076522\Unedited\1000028-thumb.jpg

*/
change "c:\ProductPhotos\" to "\\GreenDragon\ProductPhotos$\"


select max(len(sPhotoPath)) -- 66
from PJC_PathChangeTest

select max(len(sThumbnailPath)) -- 72
from PJC_PathChangeTest
