Feature: test configuration files

  Scenario: Resolver must point local resolver
    Then the value $a:/files/etc/resolv.conf/nameserver must be the string 127.0.0.1

  Scenario: The sshd configuration must be hardened
    Then the value $a:/files/etc/ssh/sshd_config/Protocol must be the string 2
    Then the value $a:/files/etc/ssh/sshd_config/UsePrivilegeSeparation must be like yes
    Then the value $a:/files/etc/ssh/sshd_config/PermitRootLogin must be like no
    Then the value $a:/files/etc/ssh/sshd_config/PermitEmptyPasswords must be like no
