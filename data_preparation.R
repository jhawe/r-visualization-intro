# Basic script to make the original data more easily accessible 
# (e.g. convert probe IDs to gene symbols, etc.)

#' Naive method to convert a set of affymetrix gene probe IDs to gene symbols
#' 
#' @param ids Vector of IDs to convert
#' 
convert_ids <- function(ids) {
  require(biomaRt)

  ensembl <- useEnsembl(biomart = "genes", dataset = "hsapiens_gene_ensembl")

  getBM(attributes = c('affy_hg_u133_plus_2', 'hgnc_symbol', 'chromosome_name',
                       'start_position', 'end_position', 'band'),
        filters = 'affy_hg_u133_plus_2',
        values = ids,
        mart = ensembl) %>%
    dplyr::select(probe = affy_hg_u133_plus_2, symbol = hgnc_symbol) %>%
    distinct() %>%
    group_by(probe) %>%
    dplyr::summarise(symbol = min(symbol))
}

# load data and get ids
data <- readr::read_csv("Breast_GSE45827.csv")
probeIDs <- colnames(data)[-c(1:2)]

symbols <- convert_ids(probeIDs)

# iterate over all symbols and get mean expression values across probes per symbol
sym <- unique(pull(symbols, symbol))
result <- lapply(sym, function(s) {
  p <- pull(filter(symbols, symbol == s), probe)
  colMeans(expression[p,,drop=F])
}) %>% bind_cols()
colnames(result) <- sym

# adjust sample types (get rid of cancer subtypes)
data_mod <-
  dplyr::bind_cols(dplyr::select(data, samples, type), result) %>%
  mutate(type = case_when(type %in% c('cell_line', 'normal') ~ type,
                          TRUE ~ 'cancer'))

# save dataset
write_tsv(data_mod, "cancer_dataset.tsv")
