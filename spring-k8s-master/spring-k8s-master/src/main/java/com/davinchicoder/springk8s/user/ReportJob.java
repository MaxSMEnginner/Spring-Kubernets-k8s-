package com.davinchicoder.springk8s.user;

import lombok.extern.slf4j.Slf4j;
import net.javacrumbs.shedlock.spring.annotation.SchedulerLock;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Slf4j
@Component
public class ReportJob {

    @Scheduled(fixedRate = 10000)
    @SchedulerLock(name = "generateReportTask", lockAtMostFor = "5m", lockAtLeastFor = "1m")
    public void generateReport() {
        log.info("🧾 Generating report at {}", LocalDateTime.now());
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        log.info("Report generated correctly");
    }
}

