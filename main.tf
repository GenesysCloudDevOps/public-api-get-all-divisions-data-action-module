resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "pageNumber" = {
                "default" = "1",
                "type" = "integer"
            }
        },
        "type" = "object"
    })
    contract_output = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "divisionIds" = {
                "items" = {
                    "type" = "string"
                },
                "type" = "array"
            },
            "divisionNames" = {
                "items" = {
                    "type" = "string"
                },
                "type" = "array"
            },
            "pageCount" = {
                "type" = "integer"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/authorization/divisions?pageSize=100&pageNumber=$${input.pageNumber}"
    }

    config_response {
        success_template = "{ \"divisionIds\": $${ids}, \"divisionNames\": $${names},\"pageCount\": $${pageCount} }"
        translation_map = { 
			ids = "$.entities[*].id"
			pageCount = "$.pageCount"
			names = "$.entities[*].name"
		}
        translation_map_defaults = {       
			ids = "[]"
			pageCount = "0"
			names = "[]"
		}
    }
}