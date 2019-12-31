--Purpose: Query to list dead transaction.
SELECT    ktuxeusn USN, ktuxeslt Slot, ktuxesqn Seq, ktuxesta State, ktuxesiz Undo
FROM      x$ktuxe
WHERE     ktuxesta <> 'INACTIVE'
AND       ktuxecfl LIKE '%DEAD%'
ORDER BY  ktuxesiz ASC;
