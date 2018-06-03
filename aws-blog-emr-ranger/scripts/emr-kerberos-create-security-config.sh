#!/usr/bin/env bash
aws emr create-security-configuration --name MyKerberosConfig \
--security-configuration '{
  "AuthenticationConfiguration": {
    "KerberosConfiguration": {
      "Provider": "ClusterDedicatedKdc",
      "ClusterDedicatedKdcConfiguration": {
        "TicketLifetimeInHours": 24,
        "CrossRealmTrustConfiguration": {
          "Realm": "EXAMPLE.COM",
          "Domain": "example.com",
          "AdminServer": "example.com ",
          "KdcServer": "example.com"
        }
      }
    }
  }
}' --region us-east-1
