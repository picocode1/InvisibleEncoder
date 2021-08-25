local ascp_chrs = string.split(" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~","")
local rplc_chrs = {536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630}
local chrs_tbl = {}
local revs_tbl = {}

for i, v in ipairs(ascp_chrs) do
    local num = tonumber("917"..rplc_chrs[i])
    chrs_tbl[v] = num
    revs_tbl[num] = v
end

local function Encode(str)
    local str_tbl = str:split("")
    local enc_tbl = {}
    for i, v in ipairs(str_tbl) do
        enc_tbl[i] = utf8.char(chrs_tbl[v])
    end
    return table.concat(enc_tbl,"")
end

local function Decode(str)
    local dec_tbl = {}
    for _, v in utf8.codes(str) do
        table.insert(dec_tbl,revs_tbl[v])
    end
    return table.concat(dec_tbl,"")
end
