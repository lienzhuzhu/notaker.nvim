-- tutorial/rendering.lua
-- Author: Lien Zhu
-- Description: Logic for rendering PDFs


local _config = require("r2pdf.setup").get_config()

local _render_pdf = function()
    local file = vim.fn.expand("%:p")
    local cmd = "Rscript -e \"rmarkdown::render('" .. file .. "')\""

    if _config.live_render then
        vim.fn.jobstart(cmd, {
            on_exit = function(_, code)
                if code == 0 then
                    vim.notify("Rendering complete: " .. file, vim.log.levels.INFO)

                    if _config.live_preview then
                        local pdf = vim.fn.expand("%:r") .. ".pdf"
                        vim.fn.jobstart(_config.pdf_reader .. " " .. pdf .. " &")
                    end

                else
                    vim.notify("Rendering failed: " .. file, vim.log.levels.ERROR)
                end
            end,
        })
    end

end

return {
    render_pdf = _render_pdf
}
