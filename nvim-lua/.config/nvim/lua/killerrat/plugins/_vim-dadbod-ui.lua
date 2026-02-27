local p = "vim-dadbod-ui"; if (not require('killerrat.plugins._lazy-nvim').LazyHasPlugin(p)) then return end
-- jdbc:sqlserver://[serverName[\instanceName][:portNumber]][;property=value[;property=value]]
-- jdbc:sqlserver://sqlserver.gouws.org;user=sa;password=your_password;database=your_db
-- sqlserver://sqlserver.gouws.org;user=sa;password=your_password;database=your_db
-- aur go-sqlcmd package is also needed

-- server=sql.mysite.devlocal\sql2016;uid=User;pwd=redacted;database=YourDatabaseName

-- SET VIM variable using neovim lua interface
-- g:db_ui_execute_on_save = 0

vim.g.db_ui_execute_on_save = 0

