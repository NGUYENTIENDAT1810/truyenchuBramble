package com.bramble.novel.dto.common;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PageResponse<T> {
    private List<T> items;
    private int page;
    private int limit;
    private long total;
    private long totalElements;
    private int totalPages;
    private boolean hasNext;
    private boolean hasPrev;

    public static class PageResponseBuilder<T> {
        public PageResponseBuilder<T> totalElements(long totalElements) {
            this.totalElements = totalElements;
            this.total = totalElements;
            return this;
        }

        public PageResponseBuilder<T> total(long total) {
            this.total = total;
            this.totalElements = total;
            return this;
        }
    }

    public static <T> PageResponse<T> from(Page<?> page, List<T> items) {
        return PageResponse.<T>builder()
                .items(items)
                .page(page.getNumber() + 1)
                .limit(page.getSize())
                .total(page.getTotalElements())
                .totalElements(page.getTotalElements())
                .totalPages(page.getTotalPages())
                .hasNext(page.hasNext())
                .hasPrev(page.hasPrevious())
                .build();
    }
}
