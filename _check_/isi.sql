SELECT T.*
  FROM MAM.MAM_ITEM_SUB_INVENTORIES T
 WHERE T.ITEM_ITEM_ID =
       (SELECT ITEM_ID FROM MAM.MAM_ITEMS I WHERE I.COD_ITEM = '&COD_ITEM')
--for update