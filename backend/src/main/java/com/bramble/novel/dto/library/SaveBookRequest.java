package com.bramble.novel.dto.library;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SaveBookRequest {
    @NotBlank(message = "Book ID is required")
    private String bookId;

    private String status; // "CURRENT", "COMPLETED", "SAVED"
}
