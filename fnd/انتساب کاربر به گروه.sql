begin
  -- Call the procedure
  fnd.fnd_usergrp_access_pkg.create_grpuser_grant_prc(p_grp_id => :p_grp_id,
                                                      p_user => :p_user,
                                                      p_result => :p_result,
                                                      p_errmsg => :p_errmsg);
end;
