# Test Case Templates

Ready-to-use templates for different types of test cases. Copy-paste into your workflow.

## Template 1: Logic Test Case (Happy Path)

```
| Section | Case | Title | Precondition | Steps | Expected Result |
|---------|------|-------|--------------|-------|-----------------|
| FEATURE_NAME | Logic | Verify [feature] works as expected | 1. User is on PDP<br>2. FEATURE is available | 1. Load PDP<br>2. Interact with FEATURE | FEATURE displays correctly<br>All elements visible and functional |
```

---

## Template 2: UI Behavior (Design Validation)

```
| Section | Case | Title | Precondition | Steps | Expected Result |
|---------|------|-------|--------------|-------|-----------------|
| FEATURE_NAME | UI Behavior | Design validation per Figma spec | 1. FEATURE rendered<br>2. Figma reference available | 1. Verify font size, weight, color<br>2. Check spacing, padding, margins<br>3. Compare with Figma | All styling matches Figma spec<br>No visual discrepancies |
```

---

## Template 3: User Interaction (Click/Hover)

```
| Section | Case | Title | Precondition | Steps | Expected Result |
|---------|------|-------|--------------|-------|-----------------|
| FEATURE_NAME | User Interaction | Click CTA navigates to next page | 1. User is on PDP<br>2. CTA button visible | 1. Click CTA button | Redirected to next page<br>URL updates correctly<br>Previous state maintained |
```

---

## Template 4: State Management (Persistence)

```
| Section | Case | Title | Precondition | Steps | Expected Result |
|---------|------|-------|--------------|-------|-----------------|
| FEATURE_NAME | State Management | State maintains after browser back | 1. User selected options A, B, C<br>2. Proceeded to next page | 1. Click browser back button | Previous selections A, B, C maintained<br>UI returns to original state |
```

---

## Template 5: E2E Flow (Complete Journey)

```
| Section | Case | Title | Precondition | Steps | Expected Result |
|---------|------|-------|--------------|-------|-----------------|
| FEATURE_NAME | E2E Flow | End-to-end: from select to booking | 1. User logged in<br>2. Ticket available<br>3. Valid payment method | 1. Select ticket<br>2. Choose date, time, pax<br>3. Click Book<br>4. Complete payment | Redirected to confirmation page<br>Booking created successfully<br>Email receipt sent |
```

---

## Template 6: Edge Case (Boundary Condition)

```
| Section | Case | Title | Precondition | Steps | Expected Result |
|---------|------|-------|--------------|-------|-----------------|
| FEATURE_NAME | Edge Cases | 0 items displays empty state | 1. Group has 0 tickets<br>2. PDP loaded | 1. Load PDP<br>2. Check group | Empty state message shown<br>"No items available" text displayed<br>No crash or error |
```

---

## Template 7: Localization (Multi-Language)

```
| Section | Case | Title | Precondition | Steps | Expected Result |
|---------|------|-------|--------------|-------|-----------------|
| FEATURE_NAME | Localization | Text displays in Bahasa Indonesia | 1. User locale set to ID<br>2. Translated text available | 1. Load PDP with ID locale | All text shows in Bahasa Indonesia<br>Fallback to English if no translation |
```

---

## Template 8: Error Handling (API Failure)

```
| Section | Case | Title | Precondition | Steps | Expected Result |
|---------|------|-------|--------------|-------|-----------------|
| FEATURE_NAME | Error Handling | API error shows error message | 1. API returns 500 error<br>2. PDP loaded | 1. Load PDP<br>2. Observe FEATURE | Error message displayed<br>No broken UI or console error<br>Graceful degradation |
```

---

## Template 9: Responsive (Viewport Testing)

```
| Section | Case | Title | Precondition | Steps | Expected Result |
|---------|------|-------|--------------|-------|-----------------|
| FEATURE_NAME | Responsive | Displays correctly at 1024px viewport | 1. Browser width set to 1024px<br>2. PDP loaded | 1. Load PDP at 1024px<br>2. Check layout | FEATURE fits within viewport<br>No horizontal scroll<br>All elements accessible |
```

---

## Template 10: Performance (Load Time)

```
| Section | Case | Title | Precondition | Steps | Expected Result |
|---------|------|-------|--------------|-------|-----------------|
| FEATURE_NAME | Performance | Loads within 2 seconds with 100+ items | 1. Group has 100 tickets<br>2. Network throttling: Fast 3G | 1. Load PDP<br>2. Measure time to interactive | FEATURE loads within 2 seconds<br>No jank or lag during scroll |
```

---

## Quick Reference: Which Template to Use?

| Test Case Type | Use Template | Example |
|----------------|---------------|---------|
| Core functionality | Template 1 (Logic) | "Section displays when data exists" |
| Visual design | Template 2 (UI Behavior) | "Font size matches Figma" |
| User actions | Template 3 (User Interaction) | "Click CTA opens modal" |
| Data persistence | Template 4 (State Management) | "Maintain state after refresh" |
| Full journey | Template 5 (E2E Flow) | "From select to booking" |
| Boundary testing | Template 6 (Edge Cases) | "0 items shows empty state" |
| Multi-language | Template 7 (Localization) | "Text in Bahasa Indonesia" |
| Network errors | Template 8 (Error Handling) | "API 500 shows error" |
| Different screens | Template 9 (Responsive) | "Works at 1024px" |
| Speed testing | Template 10 (Performance) | "Loads within 2 seconds" |

---

## Google Sheets Formatting Tips

1. **Line breaks in Steps:** Use `<br>` (not `<br>`, not `\n`)
   ```
   1. Step one<br>2. Step two<br>3. Step three
   ```

2. **Copy-paste directly:** Markdown tables are auto-parsed by Google Sheets

3. **Column widths after paste:**
   - Select all → Double-click column border to auto-fit
   - Or manually: Column A=25, B=20, C=50, D=60, E=60

4. **Header row styling:**
   - Bold + Blue background (#4472C4) + White text
   - Freeze row 1 (View → Freeze → 1 row)

---

## Example: Complete Test Case in Google Sheets Format

```
| Promotional Items | Logic | Promotional section displayed when isPromotional=TRUE tickets exist | 1. PDP loaded for attraction with ≥1 ticket tagged isPromotional=TRUE<br>2. Content config has Promotion Title, Subtitle, Background Image set | 1. Load PDP<br>2. Scroll to Ticket List section | Promotional Section displayed at top of Ticket List<br>Shows correct Promotion Title, Subtitle, Background Image |
```

**After pasting to Google Sheets:**
- Column A: "Promotional Items"
- Column B: "Logic"
- Column C: "Promotional section displayed..."
- Column D: "1. PDP loaded...<br>2. Content config..." (Shows as 2 lines)
- Column E: "1. Load PDP...<br>2. Scroll..." (Shows as 2 lines)
