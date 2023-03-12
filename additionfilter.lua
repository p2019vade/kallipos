function Image(img)
  if img.classes:find('additionc4',1) then
    local f = io.open("additionc4/" .. img.src, 'r')
    local doc = pandoc.read(f:read('*a'))
    f:close()
    local caption = pandoc.utils.stringify(doc.meta.caption) or "No Caption Found"
    local student = pandoc.utils.stringify(doc.meta.student) or "No Student Found"
    local id = pandoc.utils.stringify(doc.meta.id) or "No AM Found"
    local comment = "> " .. caption .. " Ον/μο:" .. student .. " Aριθμός Μητρώου " .. AM
    return pandoc.RawInline('markdown',comment)
  end
end
