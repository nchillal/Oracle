SELECT INST_ID, DECODE(request,0,'Holder: ','Waiter: ') || sid sess, id1, id2, lmode, request, type
FROM GV$LOCK
WHERE (id1, id2, type) IN (SELECT id1, id2, type FROM GV$LOCK WHERE request > 0)
ORDER BY id1, request;
