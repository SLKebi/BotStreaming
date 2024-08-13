
clear screen

whenever sqlerror exit sql.sqlcode

set verify off

set feedback on

set timing on

set serveroutput on

set sqlblanklines off;


define logname = '' 

set termout on
column my_logname new_val logname
select 'release_log_'||sys_context( 'userenv', 'service_name' )|| '_' || to_char(sysdate, 'YYYY-MM-DD_HH24-MI-SS')||'.log' my_logname from dual;

column my_logname clear
set termout on
spool &logname
prompt Log File: &logname





@code/yt_video.sql
@code/yt_log.sql
@code/yt_stats.sql


@../triggers/yt_video_biu.sql
@../triggers/yt_log_biu.sql
@../triggers/yt_stats_biu.sql

@../packages/youtube_utils.pks
@../packages/youtube_utils.pkb

prompt Invalid objects - pre compile
select object_name, object_type
from user_objects
where status != 'VALID'
order by object_name
;


prompt recompile invalid schema objects
begin
 dbms_utility.compile_schema(schema => user, compile_all => false);
end;
/

prompt Invalid objects - post compile
select object_name, object_type
from user_objects
where status != 'VALID'
order by object_name
;

spool off
exit
