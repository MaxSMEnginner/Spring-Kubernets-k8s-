package com.davinchicoder.springk8s.user;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.Instant;

@Entity
@Table(name = "shedlock")
public class ShedLockEntity {

    @Id
    private String name;

    private Instant lockUntil;
    private Instant lockedAt;
    private String lockedBy;
}

