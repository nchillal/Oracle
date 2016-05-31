# Purpose: Query to list dead transaction.

select ktuxeusn USN, ktuxeslt Slot, ktuxesqn Seq, ktuxesta State, ktuxesiz Undo 
from x$ktuxe 
where ktuxesta <> 'INACTIVE' and ktuxecfl like '%DEAD%' order by ktuxesiz asc;
