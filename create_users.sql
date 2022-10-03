-- Agents
CREATE USER SFREEMAN IDENTIFIED BY password;
CREATE USER CKLEIN IDENTIFIED BY password;
CREATE USER MCURTIS IDENTIFIED BY password;
CREATE USER JHUNTER IDENTIFIED BY password;
CREATE USER KJACKSON IDENTIFIED BY password;
CREATE USER ECARPENTER IDENTIFIED BY password;
CREATE USER AMYERS IDENTIFIED BY password;

-- Grant create session
GRANT CREATE SESSION TO SFREEMAN, CKLEIN, MCURTIS, JHUNTER, KJACKSON, ECARPENTER, AMYERS;

-- Grant read
GRANT READ ON CUSTOMER TO SFREEMAN, CKLEIN, MCURTIS, JHUNTER, KJACKSON, ECARPENTER, AMYERS;
GRANT READ ON AGENT TO SFREEMAN, CKLEIN, MCURTIS, JHUNTER, KJACKSON, ECARPENTER, AMYERS;
GRANT READ ON PAYMENT TO SFREEMAN, CKLEIN, MCURTIS, JHUNTER, KJACKSON, ECARPENTER, AMYERS;