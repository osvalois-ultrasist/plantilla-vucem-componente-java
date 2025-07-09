package mx.gob.vucem.componente.infrastructure.config;

import io.github.resilience4j.circuitbreaker.CircuitBreakerConfig;
import io.github.resilience4j.circuitbreaker.CircuitBreakerRegistry;
import io.github.resilience4j.core.registry.EntryAddedEvent;
import io.github.resilience4j.retry.RetryConfig;
import io.github.resilience4j.retry.RetryRegistry;
import io.github.resilience4j.timelimiter.TimeLimiterConfig;
import io.github.resilience4j.timelimiter.TimeLimiterRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.circuitbreaker.resilience4j.Resilience4JCircuitBreakerFactory;
import org.springframework.cloud.circuitbreaker.resilience4j.Resilience4JConfigBuilder;
import org.springframework.cloud.client.circuitbreaker.Customizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;

/**
 * Configuración de resiliencia para la aplicación.
 * Define la configuración de circuit breaker, retry y timeout.
 */
@Configuration
public class ResilienceConfig {
    private static final Logger logger = LoggerFactory.getLogger(ResilienceConfig.class);

    @Value("${vucem.circuit-breaker.enabled:true}")
    private boolean circuitBreakerEnabled;

    @Value("${vucem.circuit-breaker.timeout:5s}")
    private Duration timeout;

    @Value("${vucem.circuit-breaker.retry-attempts:3}")
    private int retryAttempts;

    @Value("${vucem.circuit-breaker.failure-rate-threshold:50}")
    private float failureRateThreshold;

    /**
     * Configura el registry de CircuitBreaker para monitoreo
     */
    @Bean
    public CircuitBreakerRegistry circuitBreakerRegistry() {
        CircuitBreakerConfig circuitBreakerConfig = CircuitBreakerConfig.custom()
                .slidingWindowSize(10)
                .failureRateThreshold(failureRateThreshold)
                .waitDurationInOpenState(Duration.ofSeconds(10))
                .permittedNumberOfCallsInHalfOpenState(5)
                .slowCallRateThreshold(50)
                .slowCallDurationThreshold(Duration.ofSeconds(2))
                .build();

        CircuitBreakerRegistry registry = CircuitBreakerRegistry.of(circuitBreakerConfig);

        // Registrar listeners para eventos del circuit breaker
        registry.getEventPublisher()
                .onEntryAdded(event -> logger.info("CircuitBreaker {} added", event.getAddedEntry().getName()));

        return registry;
    }

    /**
     * Configura el registry de Retry para monitoreo
     */
    @Bean
    public RetryRegistry retryRegistry() {
        RetryConfig retryConfig = RetryConfig.custom()
                .maxAttempts(retryAttempts)
                .waitDuration(Duration.ofMillis(500))
                .retryExceptions(Exception.class)
                .build();

        return RetryRegistry.of(retryConfig);
    }

    /**
     * Configura el registry de TimeLimiter para monitoreo
     */
    @Bean
    public TimeLimiterRegistry timeLimiterRegistry() {
        TimeLimiterConfig timeLimiterConfig = TimeLimiterConfig.custom()
                .timeoutDuration(timeout)
                .build();

        return TimeLimiterRegistry.of(timeLimiterConfig);
    }

    /**
     * Configura el circuit breaker global para la aplicación.
     *
     * @return Customizer para el circuit breaker factory
     */
    @Bean
    public Customizer<Resilience4JCircuitBreakerFactory> defaultCustomizer() {
        return factory -> {
            factory.configureDefault(id -> new Resilience4JConfigBuilder(id)
                    .timeLimiterConfig(TimeLimiterConfig.custom()
                            .timeoutDuration(timeout)
                            .build())
                    .circuitBreakerConfig(CircuitBreakerConfig.custom()
                            .slidingWindowSize(10)
                            .failureRateThreshold(failureRateThreshold)
                            .waitDurationInOpenState(Duration.ofSeconds(10))
                            .permittedNumberOfCallsInHalfOpenState(5)
                            .slowCallRateThreshold(50)
                            .slowCallDurationThreshold(Duration.ofSeconds(2))
                            .build())
                    .build());

            // Registrar CircuitBreakers predefinidos si es necesario
            if (circuitBreakerEnabled) {
                factory.configure(builder -> builder
                                .circuitBreakerConfig(CircuitBreakerConfig.ofDefaults())
                                .timeLimiterConfig(TimeLimiterConfig.custom().timeoutDuration(timeout).build()),
                        "defaultCircuitBreaker");
            }
        };
    }
}