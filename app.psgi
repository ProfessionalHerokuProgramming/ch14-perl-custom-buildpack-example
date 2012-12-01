#!/usr/bin/perl

use DBI;

my $app = sub {

    # Connect to Heroku Postgres DB
    my($user, $password, $host, $port, $name) = 
        $ENV{"DATABASE_URL"} =~ m/postgres:\/\/(.+?):(.+?)\@(.+?):(\d+?)\/(.*?)$/;
    my $dbh = DBI->connect("DBI:Pg:dbname=$name;host=$host", $user, $password, 
        {'RaiseError' => 1});
    
    # Execute SELECT SQL query
    my $sth = $dbh->prepare("SELECT * FROM employees");
    $sth->execute();
    
    # Loop through result records
    while(my $ref = $sth->fetchrow_hashref()) {
        $result_string .= "<tr>";
        $result_string .= "<td>$ref->{'id'}</td>";
        $result_string .= "<td>$ref->{'name'}</td>";
        $result_string .= "<td>$ref->{'email'}</td>";
        $result_string .= "</tr>";
    }
    
    $dbh->disconnect();
    
    return [200, ['Content-Type' => 'text/html'], ["
        <head>
            <title>Employee List</title>
        </head>
        
        <body>
            <h1>Employee List</h1>
            
            <table>
                <tr>
                    <th>Employee ID</th>
                    <th>Name</th>
                    <th>E-mail Address</th>
                </tr>                
    " . $result_string . "
            </table>
        </body>
    </html>"]];
}
